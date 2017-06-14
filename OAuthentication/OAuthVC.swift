//
//  OAuthVC.swift
//  OAuthentication
//
//  Created by Sayantan Chakraborty on 08/06/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import SAPFoundation
import SAPCommon

class OAuthVC: UIViewController, SAPURLSessionDelegate, Notifier {
    
    private var sapUrlSession: SAPURLSession!
    private let logger: Logger = Logger.shared(named: "OAuthVC")
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        self.setupAuthenticator()
        
        self.logger.info("Requesting OAuth2 token...")
        self.send()
    }
    
    private func send() {
        
        self.logger.info("Send function is invoked.")
        
        let request = URLRequest(url: Constants.resourceURL)
        
        let dataTask = sapUrlSession.dataTask(with: request) { data, urlResponse, error in
            if let data = data, let _ = urlResponse {
                
                self.logger.info("Resonse: \(String(describing: String(data: data, encoding: String.Encoding.utf8)))")
                self.appDelegate.urlSession = self.sapUrlSession
                
                // Subscribe for remote notification
                //self.appDelegate.registerForRemoteNotification()
                
                DispatchQueue.main.async {
                    //self.hideActivityIndicator(self.activityIndicator)
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let controller = storyboard.instantiateViewController(withIdentifier: "someViewController")
//                    self.present(controller, animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                
                self.logger.error("Failed! Status: \(String(describing: (urlResponse as? HTTPURLResponse)?.statusCode)), Error: \(String(describing: error))")
                DispatchQueue.main.async {
                    self.displayAlert(title: NSLocalizedString("keyErrorLogonProcessFailedNoResponseTitle", value: "Logon process failed!", comment: "XTIT: Title of alert message about logon process failure."), message: error!.localizedDescription, buttonText: NSLocalizedString("keyOkButtonLogonProcessFailureNoResponse", value: "OK", comment: "XBUT: Title of OK button."))
                }
            }
        }
        dataTask.resume()
    }
    
    // MARK: - Private
    private func setupAuthenticator() {
        let scopesArray: [String] = []
        let scopes = Set<String>(scopesArray)
        
        let parameters = OAuth2AuthenticationParameters(authorizationEndpointURL: URL(string: Constants.authURL)!, clientID: Constants.clientID, redirectURL: URL(string: Constants.redirectURL)!, tokenEndpointURL: URL(string: Constants.tokenURL)!, requestingScopes: scopes)
        
        sapUrlSession = SAPURLSession(delegate: self)
        sapUrlSession.register(SAPcpmsObserver(settingsParameters: Constants.configurationParameters))
        
        let authenticator = OAuth2Authenticator(authenticationParameters: parameters, sapURLSession: sapUrlSession, webViewPresenter: WKWebViewPresenter())
        let oauthObserver = OAuth2Observer(authenticator: authenticator, tokenStore: appDelegate)
        
        sapUrlSession.register(oauthObserver)
    }
    
    /// Note: This automatic server trust is for only testing purposes. The intented use is to install certificate to the device. Do not use it productively!
    func sapURLSession(_ session: SAPURLSession, task: SAPURLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping(SAPURLSession.AuthChallengeDisposition) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.use(credential))
        } else {
            completionHandler(.performDefaultHandling)
        }
    }
}
