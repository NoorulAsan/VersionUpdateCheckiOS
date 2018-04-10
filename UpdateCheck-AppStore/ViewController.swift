//
//  ViewController.swift
//  UpdateCheck-AppStore
//
//  Created by MacMini on 10/04/18.
//  Copyright © 2018 Noorul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            DispatchQueue.global().async {
                do {
                    let update = self.isUpdateAvailable()
                    print("update",update)
                    DispatchQueue.main.async {
                        if update{
                            self.popupUpdateDialogue();
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        else {
            print("Internet Connection not Available!")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    // MARK: - Navigation
    func isUpdateAvailable() -> Bool {
        let info = Bundle.main.infoDictionary
        let currentVersion = info!["CFBundleShortVersionString"] as? String
        let identifier = info!["CFBundleIdentifier"] as? String
        if let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier!)") {
            let data = try? Data(contentsOf: url)
            let json = try? JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: Any]
            if let result = (json!!["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
                print("version in app store", version, currentVersion!)
                return version != currentVersion
            }
        }
        return false
    }
    
    func popupUpdateDialogue()
    {
        let alertMessage = "A new version of TrackEHS app is available, Please update to new version" //+ versionInfo;
        let alert = UIAlertController(title: "New Version Available", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okBtn = UIAlertAction(title: "Update", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if let url = URL(string: "itms-apps://itunes.apple.com/us/app/link"), //Change App Link
                UIApplication.shared.canOpenURL(url){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        })
        let noBtn = UIAlertAction(title:"Remind me later" , style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        alert.addAction(okBtn)
        alert.addAction(noBtn)
        self.present(alert, animated: true, completion: nil)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

