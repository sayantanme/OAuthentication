//
// AppDelegate.swift
// OAuthentication
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 08/06/17
//

import UIKit
import SAPFoundation
import SAPFiori
import SAPCommon

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,OAuth2TokenStore {

    var window: UIWindow?
    var oauthDidFinishLoad: ((URL?) -> Void)?
    private let logger: Logger = Logger.shared(named: "AppDelegateLogger")
    var oauth2Token: OAuth2Token?
    var espmContainer: ESPMContainerDataAccess!
    var urlSession: SAPURLSession? {
        didSet {
            self.espmContainer = ESPMContainerDataAccess(urlSession: urlSession!)
            self.uploadLogs()
            //self.startScheduledUpload()
        }
    }
    var scheduledUploadTimer: DispatchSourceTimer?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // set the default log level. Note: LogLevel.all may be too much for your use case! Maybe prefer LogLevel.error.
        Logger.root.logLevel = LogLevel.debug
        
        do {
            // Attaches a LogUploadFileHandler instance to the root of the logging system.d
            try SAPcpmsLogUploader.attachToRootLogger()
        } catch {
            self.logger.error("Failed to attach to root logger. Error: \(error.localizedDescription)")
        }
        
        UINavigationBar.applyFioriStyle()
        
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let leftNavController = splitViewController.viewControllers.first as! UINavigationController
        let masterViewController = leftNavController.topViewController as! ViewController
        let rightNavController = splitViewController.viewControllers[1] as! UINavigationController
        let detailViewController = rightNavController.topViewController as! CustomerDataTVC
        masterViewController.delegate = detailViewController
        
        // Show the actual authentication' view controller
        self.window?.makeKeyAndVisible()
        let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
        if (storyboard != nil) {
            let splitViewController = self.window!.rootViewController as! UISplitViewController
            let logonViewController = (storyboard?.instantiateViewController(withIdentifier: "OAuthVC"))! as! OAuthVC
            splitViewController.modalPresentationStyle = UIModalPresentationStyle.currentContext
            splitViewController.preferredDisplayMode = .allVisible
            splitViewController.present(logonViewController, animated: false, completion: {})
        }
        print("\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        //scheduledUploadTimer?.suspend()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //self.stopScheduledUpload()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        if self.scheduledUploadTimer != nil {
//            self.scheduledUploadTimer!.resume()
//        }
//        else {
//            self.startScheduledUpload()
//        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //scheduledUploadTimer?.resume()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    private func uploadLogs() {
        guard let sapUrlSession = self.urlSession else {
            return
        }
        let sapcpmsConfigurationParameters = SAPcpmsSettingsParameters(backendURL: Constants.sapcpmsUrl, applicationID: Constants.appId)
        SAPcpmsLogUploader.uploadLogs(sapURLSession: sapUrlSession, settingsParameters: sapcpmsConfigurationParameters, completionHandler: { error in
            if let error = error {
                
                self.logger.error("Error happened during log upload: \(error.localizedDescription)")
                return
            }
            
            self.logger.info("Logs have been uploaded successfully.")
        })
    }
    
    // MARK: - OAuth2TokenStore
    public func deleteToken(for url: URL) {
        oauth2Token = nil
    }
    
    public func token(for url: URL) -> OAuth2Token? {
        return oauth2Token
    }
    
    public func store(token: OAuth2Token, for url: URL) {
        oauth2Token = token
    }
}
