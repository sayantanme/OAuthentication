//
//  Constants.swift
//  OAuthentication
//
//  Created by Sayantan Chakraborty on 08/06/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import Foundation
import SAPFoundation

enum CollectionType: String {
    case salesOrderHeaders = "SalesOrderHeaders"
    case productTexts = "ProductTexts"
    case suppliers = "Suppliers"
    case purchaseOrderItems = "PurchaseOrderItems"
    case stock = "Stock"
    case customers = "Customers"
    case productCategories = "ProductCategories"
    case salesOrderItems = "SalesOrderItems"
    case purchaseOrderHeaders = "PurchaseOrderHeaders"
    case products = "Products"
    case none = ""
    
    static let allValues: [CollectionType] = [
        salesOrderHeaders, productTexts, suppliers, purchaseOrderItems, stock, customers, productCategories, salesOrderItems, purchaseOrderHeaders, products]
}

struct Constants {
    
    static let appId = "com.sayantan.OAuthentication"
    private static let sapcpmsUrlString = "https://hcpms-p1942665858trial.hanatrial.ondemand.com/"
    static let sapcpmsUrl = URL(string: sapcpmsUrlString)!
    static let appUrl = Constants.sapcpmsUrl.appendingPathComponent(appId)
    static let authURL = "https://oauthasservices-p1942665858trial.hanatrial.ondemand.com/oauth2/api/v1/authorize"
    static let endUserUi = URL(string: "https://oauthasservices-p1942665858trial.hanatrial.ondemand.com/oauth2")!
    static let tokenURL = "https://oauthasservices-p1942665858trial.hanatrial.ondemand.com/oauth2/api/v1/token"
    static let clientID = "9d2ae8f2-503b-4286-ba60-ac2fb3a5e352"
    static let resourceURL = appUrl.appendingPathComponent("SalesOrderHeaders")
    static let redirectURL = endUserUi.absoluteString //appId + "://" + endUserUi.host! + endUserUi.path
    static let configurationParameters = SAPcpmsSettingsParameters(backendURL: Constants.sapcpmsUrl, applicationID: Constants.appId)

}


