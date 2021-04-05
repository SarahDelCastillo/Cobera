//
//  OptionItemListViewController.swift
//  Popover
//
//  Created by Emilio Del Castillo on 04/04/2021.
//

import UIKit

protocol OptionItemListViewControllerDelegate: AnyObject {
    /**
     Tells the delegate an option has been selected.
     - Parameter viewController: The popover view controller.
     - Parameter item: The selected item.
     
     The delegate must handle the dismissal of the popover in this method.
     */
    func didSelectOptionItem(from viewController: OptionPopoverViewController, with item: OptionItem)
}

class OptionPopoverViewController: UIViewController {
    
    /**
     Every sub-array corresponds to a different section of the presented table view.
     */
    var items = [[OptionItem]]() {
        didSet {
            calculateAndSetPreferredContentSize()
        }
    }
    
    /**
     Customize the height of the separator view between sections
     */
    let sectionSeparatorHeight: CGFloat = 4
    
    /**
     The row height depends on the item text height. (But that's not implemented yet)
     
     44 is the default height for a UItableViewCell
     */
    private var rowHeight: CGFloat = 44
    
    private(set) weak var tableView: UITableView?
    weak var delegate: OptionItemListViewControllerDelegate?
    
    //MARK: - Required inits
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .popover
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setting the tableView
    // This view controller only contains a UITableView
    override func loadView() {
        view = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView = (view as! UITableView)
        tableView?.isScrollEnabled = false
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.separatorInset.left = 0
        tableView?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView!.frame.size.width, height: 1))
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
 
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        /* The arrow would crop the top of the table view. This solution feels like a hack but I
         don't know any better solution */
        tableView?.contentInset = UIEdgeInsets(top: tableView!.safeAreaInsets.top, left: 0, bottom: 0, right: 0)
        
    }
    
    //MARK: - Computing the size of the view
    
    /**
     Sets the `preferredContentSize` var to fit all the items.
     */
    func calculateAndSetPreferredContentSize() {
        let approxAccessoryViewWidth: CGFloat = 80

        /* This is scary looking, but it's really not that complicated.
         1) .flatMap creates a one-dimension array with all the items:
            [[a],[b],[c]] becomes [a, b, c]
        
         2) .reduce returns the biggest size among [a, b, c]        */
        let maxWidth = items.flatMap{ $0 }.reduce(0) {
            ($1.sizeForDisplayText().width + approxAccessoryViewWidth > $0) ? $1.sizeForDisplayText().width + approxAccessoryViewWidth : $0
        }
        
        let numberOfItems = CGFloat(items.flatMap{ $0 }.count)
        let numberOfSections = CGFloat(items.count)
        
        // Let us remember that we don't need to have the separator height if we only have one section
        let totalHeight = (numberOfItems * rowHeight) + (sectionSeparatorHeight * numberOfSections - 1)
        preferredContentSize = CGSize(width: maxWidth, height: totalHeight)
    }
}
