//
//  ScannerViewController.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 01/04/2021.
//

import AVFoundation
import UIKit

protocol ScannerViewControllerDelegate {
    func found(code: String)
}


class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var previewView: UIView!
    
    
    var delegate: ScannerViewControllerDelegate!
    var barcode: String!
    var product: Product!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
            
        } else {
            failed()
            return
        }
        
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        let cornerRadius: CGFloat = 20
        
        previewView.layer.cornerRadius = cornerRadius
        previewLayer.cornerRadius = cornerRadius
        
        previewLayer.videoGravity = .resizeAspectFill
        
        previewView.layer.addSublayer(previewLayer)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewDidLayoutSubviews() {
        previewLayer.frame = previewView.bounds
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
        
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue
            else { return }
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            barcode = stringValue
            
            // Print the scanned code
            print("Scanned:", stringValue)
            getProductFromBarcode(stringValue)

        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func getProductFromBarcode(_ barcode: String){
        AppData.shared.readBarcode(barcode) { (product) in
            
            // If it exists...
            if product != nil {
                self.product = product
                self.performSegue(withIdentifier: "show product detail", sender: self)
                
            } else {
                self.performSegue(withIdentifier: "show product form", sender: self)
                
            }
        }
    }
    
}

extension ScannerViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "show product detail":
            if let destinationVC = segue.destination as? ProductDetailVC {
                destinationVC.product = product
            }
            
        case "show product form":
            if let destinationVC = segue.destination as? ProductFormVC {
                destinationVC.barcode = barcode
            }
            
        default:
            print("Segue identifier: ", segue.identifier!)
        }
    }
}
