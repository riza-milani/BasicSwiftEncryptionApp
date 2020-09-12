//
//  ViewController.swift
//  BasicEncryptionApp
//
//  Created by riza milani on 6/22/1399 AP.
//  Copyright © 1399 reza milani. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    let mainViewModel = MainViewModel()
    @IBOutlet weak var aesCBCModeSwitch: UISwitch!
    @IBOutlet weak var aesKeySize256Switch: UISwitch!
    @IBOutlet weak var urlTextView: UITextField!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        mainViewModel.viewController = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func enterPasswordAction(_ sender: Any) {
        mainViewModel.showDetailView(url: urlTextView.text,
                                     aesCBCMode: aesCBCModeSwitch.isOn ,
                                     aesSize256: aesKeySize256Switch.isOn)
    }
}

