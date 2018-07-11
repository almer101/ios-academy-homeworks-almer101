//
//  LoginViewController.swift
//  TVShows
//
//  Created by Ivan Almer on 11/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = String(count)
        label.textColor = UIColor.blue
        label.font = UIFont(name: "Avenir-HeavyOblique", size: 30)
        label.frame.size = CGSize(width: 100, height: 40)
        button.layer.cornerRadius = 15
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        activityIndicator.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            sleep(3)
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        activityIndicator.isHidden = false
        
        count += 1
        label.text = String(count)
        
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            sleep(3)
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            sender.isEnabled = true
        }
    }
    
}
