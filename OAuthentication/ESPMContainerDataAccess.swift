//
//  ESPMContainerDataAccess.swift
//  OAuthentication
//
//  Created by Sayantan Chakraborty on 08/06/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import Foundation
import SAPCommon
import SAPFoundation
import SAPOData
import SAPOfflineOData

class ESPMContainerDataAccess {
    //var service: ESPMContainer<OnlineODataProvider>
    private let espmOdataService: ESPMContainer<OnlineODataProvider>
    private var offlineService: ESPMContainer<OfflineODataProvider>
    //var offlineODataProvider: OfflineODataProvider
    private(set) var isOfflineStoreOpened = false // variable is internal (app) read and private write
    private let logger: Logger = Logger.shared(named: "ServiceDataAccessLogger")
    
    init(urlSession: SAPURLSession) {
        
        //ONLINE
        let odataProvider = OnlineODataProvider(serviceName: "myServiceName", serviceRoot: Constants.appUrl)
        odataProvider.sapURLSession = urlSession
        
        espmOdataService = ESPMContainer(provider: odataProvider)
        // To update entity force to use X-HTTP-Method header
        _ = espmOdataService.networkOptions.tunneledMethods.append("MERGE")
        
        
        //OFFLINE
        
        var offlineParameters = OfflineODataParameters()
        
        // append the X-SMP-APPID header
        offlineParameters.customHeaders = ["X-SMP-APPID": Constants.appId]
        offlineParameters.storeName = "OFFLINE_STORE"
        offlineParameters.enableRepeatableRequests = true
        
        // create offline data provider
        let offlineODataProvider = try! OfflineODataProvider(
            serviceRoot: Constants.appUrl,
            parameters: offlineParameters,
            sapURLSession: urlSession
        )
        
        // define offline defining query
        try! offlineODataProvider.add(
            definingQuery: OfflineODataDefiningQuery(
                name: CollectionType.products.rawValue,
                query: "/\(CollectionType.products.rawValue)",
                automaticallyRetrievesStreams: false
            )
        )
        
        try! offlineODataProvider.add(
            definingQuery: OfflineODataDefiningQuery(
                name: CollectionType.customers.rawValue,
                query: "/\(CollectionType.customers.rawValue)",
                automaticallyRetrievesStreams: false
            )
        )
        
        self.offlineService = ESPMContainer(provider: offlineODataProvider)
        
        
        self.openOfflineStore{_ in }
    }
    
    
    /// opens the offline store. if store does not exists it will trigger the initial download of the store and create the local DB
    ///
    /// - Returns: returns the status
    func openOfflineStore(completionHandler: @escaping (String) -> Void) {
        guard !isOfflineStoreOpened else {
            completionHandler("Offline store opened.")
            return
        }
        /// The OfflineODataProvider needs to be opened before performing any operations.
        
        offlineService.open { error in
            if let error = error {
                completionHandler("Could not open offline store. \(error.localizedDescription)")
                return
            }
            self.isOfflineStoreOpened = true
            completionHandler("Offline store opened.")
        }
    }
    
    /// closes the offline store
    ///
    /// - Returns: returns the status
    func closeOfflineStore() -> String {
        if isOfflineStoreOpened {
            do {
                /// the Offline store should be closed when it is no longer used.
                try offlineService.close()
                isOfflineStoreOpened = false
            } catch {
                return String("Offline Store closing failed")
            }
        }
        return String("Offline Store closed")
    }
    
    
    /// loads all products and their items
    ///
    /// - Returns: list of products
    /// - Throws: error
    func loadProducts(completionHandler: @escaping (_ result: [Product]?, _ error: String?) -> Void) {
        
        let query = DataQuery().selectAll().top(20)
        
        if isOfflineStoreOpened {
            /// the same query as it was set up for the online use can be fired against the initialised the offline Odata Service
            offlineService.products(query: query) { products, error in
                if let error = error {
                    completionHandler(nil, "Loading Sales Orders failed \(error.localizedDescription)")
                    return
                }
                completionHandler(products!, nil)
            }
        } else {
            espmOdataService.products(query: query) { products, error in
                if let error = error {
                    completionHandler(nil, "Loading Sales Orders failed \(error.localizedDescription)")
                    return
                }
                completionHandler(products!, nil)
            }
        }
    }
    
    /// loads all customers and their items
    ///
    /// - Returns: list of customers
    /// - Throws: error
    func loadCustomers(completionHandler: @escaping (_ result: [Customer]?, _ error: String?) -> Void) {
        
        let query = DataQuery().selectAll().top(20)
        
        if isOfflineStoreOpened {
            /// the same query as it was set up for the online use can be fired against the initialised the offline Odata Service
            offlineService.customers(query: query) { customers, error in
                if let error = error {
                    completionHandler(nil, "Loading Sales Orders failed \(error.localizedDescription)")
                    return
                }
                completionHandler(customers!, nil)
            }
        } else {
            espmOdataService.customers(query: query) { customers, error in
                if let error = error {
                    completionHandler(nil, "Loading Sales Orders failed \(error.localizedDescription)")
                    return
                }
                completionHandler(customers!, nil)
            }
        }
    }
     /* Previous Online Code
//    // -------DataRequesterForEntity: SalesOrderHeaders -------
//    func loadSalesOrderHeaders(completionHandler: @escaping([SalesOrderHeader]?, Error?) -> Void) {
//        self.executeRequest(self.service.salesOrderHeaders, completionHandler: completionHandler)
//    }
//    
//    // -------DataRequesterForEntity: ProductTexts -------
//    func loadProductTexts(completionHandler: @escaping([ProductText]?, Error?) -> Void) {
//        self.executeRequest(self.service.productTexts, completionHandler: completionHandler)
//    }
//    
//    // -------DataRequesterForEntity: Suppliers -------
//    func loadSuppliers(completionHandler: @escaping([Supplier]?, Error?) -> Void) {
//        self.executeRequest(self.service.suppliers, completionHandler: completionHandler)
//    }
//    
//    // -------DataRequesterForEntity: PurchaseOrderItems -------
//    func loadPurchaseOrderItems(completionHandler: @escaping([PurchaseOrderItem]?, Error?) -> Void) {
//        self.executeRequest(self.service.purchaseOrderItems, completionHandler: completionHandler)
//    }
//    
//    // -------DataRequesterForEntity: Stock -------
//    func loadStock(completionHandler: @escaping([Stock]?, Error?) -> Void) {
//        self.executeRequest(self.service.stock, completionHandler: completionHandler)
//    }
//    
    // -------DataRequesterForEntity: Customers -------
//    func loadCustomers(completionHandler: @escaping([Customer]?, Error?) -> Void) {
//        self.executeRequest(self.espmOdataService.customers, completionHandler: completionHandler)
//    }
//
//    // -------DataRequesterForEntity: ProductCategories -------
//    func loadProductCategories(completionHandler: @escaping([ProductCategory]?, Error?) -> Void) {
//        self.executeRequest(self.service.productCategories, completionHandler: completionHandler)
//    }
//    
//    // -------DataRequesterForEntity: SalesOrderItems -------
//    func loadSalesOrderItems(completionHandler: @escaping([SalesOrderItem]?, Error?) -> Void) {
//        self.executeRequest(self.service.salesOrderItems, completionHandler: completionHandler)
//    }
//    
//    // -------DataRequesterForEntity: PurchaseOrderHeaders -------
//    func loadPurchaseOrderHeaders(completionHandler: @escaping([PurchaseOrderHeader]?, Error?) -> Void) {
//        self.executeRequest(self.service.purchaseOrderHeaders, completionHandler: completionHandler)
//    }
//    
//    // -------DataRequesterForEntity: Products -------
//    func loadProducts(completionHandler: @escaping([Product]?, Error?) -> Void) {
//        self.executeRequest(self.espmOdataService.products, completionHandler: completionHandler)
//    }
    
//    private func executeRequest<T>(_ request: @escaping(DataQuery) throws -> [T],
//                                completionHandler: @escaping([T]?, Error?) -> Void) {
//        DispatchQueue.global().async {
//            let query = DataQuery().selectAll()
//            do {
//                let result = try request(query)
//                completionHandler(result, nil)
//            } catch let error {
//                
//                print("Error happened in the downloading process. Error: \(error)")
//                completionHandler(nil, error)
//            }
//        }
//    }
    
 */
    
}
