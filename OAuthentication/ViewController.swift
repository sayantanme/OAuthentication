//
//  CustomerDataTVC.swift
//  OAuthentication
//
//  Created by Sayantan Chakraborty on 09/06/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit
import SAPFiori


class ViewController: UITableViewController {

    private var dA: ESPMContainerDataAccess? = nil
    var collections = [String]()
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedIndexPath : IndexPath?
    weak var delegate: MasterDetailCustomerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dA = appDelegate.espmContainer
        collections = CollectionType.allValues.map({ (collectionType) -> String in
            return collectionType.rawValue
        }).filter{$0 == CollectionType.customers.rawValue || $0 == CollectionType.products.rawValue}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    // MARK: - UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUISimplePropertyFormCell.reuseIdentifier, for: indexPath) as! FUISimplePropertyFormCell
        cell.keyName = self.collections[indexPath.row]
        cell.valueTextField.isHidden = true
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let selectedCollectionType = CollectionType(rawValue: collections[indexPath.row])
        self.delegate?.showDetail(type: selectedCollectionType!)
        //performSegue(withIdentifier: "showCustomerDetails", sender: self)
//        if let detailViewController = self.delegate as? CustomerDataTVC {
//            splitViewController?.showDetailViewController(detailViewController, sender: nil)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedRow = self.tableView.indexPathForSelectedRow?.row {
            print("CollectionType:\(CollectionType(rawValue: collections[selectedRow])!)")
            let selectedCollectionType = CollectionType(rawValue: collections[selectedRow])
            
            switch selectedCollectionType! {
            case .customers:
                if segue.destination is CustomerDataTVC {
                    
                }
            default:
                print("unknown")
            }
        }
    }
}
