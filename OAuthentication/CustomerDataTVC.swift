//
//  CustomerDataTVC.swift
//  OAuthentication
//
//  Created by Sayantan Chakraborty on 09/06/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit
import SAPFoundation
import SAPOData
import SAPCommon
import SAPFiori

class CustomerDataTVC: UITableViewController,MasterDetailCustomerDelegate,ActivityIndicator {

    private var dA: ESPMContainerDataAccess? = nil
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var _entities = [Customer]()
    var entities = [EntityValue]()
    private var activityIndicator: UIActivityIndicatorView!
//    var entities: [EntityValue] {
//        get { return _entities }
//        set { self._entities = newValue as! [Customer]
//        }
//    }
    private var collectionType:CollectionType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator = self.initActivityIndicator()
        self.activityIndicator.center = self.tableView.center
        self.tableView.addSubview(self.activityIndicator)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        //getCustomerData()
    }
    
    fileprivate func getCustomerData(){
        dA?.loadCustomers(completionHandler: { (customer, error) in
            guard let customers = customer else {
                print("error")
                return
            }
            print(customers)
            print(customers.count)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.hideActivityIndicator(self.activityIndicator)
            }
            self.entities = customers
        })
    }
    
    fileprivate func getProductsData(){
        dA?.loadProducts(completionHandler: { (product, error) in
            guard let products = product else {
                print("error")
                return
            }
            print(products)
            print(products.count)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.hideActivityIndicator(self.activityIndicator)
            }
            self.entities = products
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch collectionType! {
        case CollectionType.customers:
            
            let cell = (tableView.dequeueReusableCell(withIdentifier: "FUIContactCell", for: indexPath) as? FUIContactCell)!
            let activities = [FUIActivityItem.phone, FUIActivityItem.message]
            let customer = entities[indexPath.row] as? Customer
            cell.detailImage = UIImage(named: "contactIcon.jpg")
            cell.headlineLabel.text = "\(customer?.firstName! ?? "") \(customer?.lastName! ?? "")"
            cell.subheadlineText = customer?.emailAddress ?? ""
            cell.descriptionLabel.text = customer?.country ?? ""
            cell.activityControl.addActivities(activities)
            return cell
            
        case .products:
            
            let cell = (tableView.dequeueReusableCell(withIdentifier: "FUIObjectCell", for: indexPath) as? FUIObjectTableViewCell)!
            let product = entities[indexPath.row] as? Product
            //cell.detailImage = UIImage(named: (product?.pictureUrl)!)
            cell.headlineText = "\(product?.category! ?? "")"
            cell.subheadlineText = product?.categoryName ?? ""
//            cell.descriptionLabel.lineBreakMode = .byWordWrapping
//            cell.descriptionLabel.numberOfLines = 0
            cell.descriptionText = product?.longDescription ?? ""
            //cell.statusText = product?.pictureUrl
            //cell.activityControl.addActivities(activities)
            return cell

        default:
            return UITableViewCell()
        }
        
        
    }
    

    //MARK: - MasterDetailCustomerDelegate
    func showDetail(type: CollectionType) {
        print(type)
        dA = appDelegate.espmContainer
        switch type {
        case .customers:
            self.showActivityIndicator(self.activityIndicator)
            collectionType = CollectionType.customers
            self.navigationItem.title = "Customers"
            tableView.register(FUIContactCell.self, forCellReuseIdentifier: "FUIContactCell")
            getCustomerData()
        case .products:
            self.showActivityIndicator(self.activityIndicator)
            collectionType = CollectionType.products
            self.navigationItem.title = "Products"
            tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: "FUIObjectCell")
            getProductsData()
        default:
            print("Unknown")
        }
    }
}
