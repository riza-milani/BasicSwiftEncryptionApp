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
    var aesCBCMode = true
    var aesKetSize256 = true
    @IBOutlet weak var urlTextView: UITextField!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        mainViewModel.viewController = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func enterPasswordAction(_ sender: Any) {
        mainViewModel.showDetailView(url: urlTextView.text, aesCBCMode: aesCBCMode , aesSize256: aesKetSize256)
    }

    @IBAction func aesModeAction(_ sender: UISwitch) {
        aesCBCMode = sender.isOn
    }

    @IBAction func aesKeyAction(_ sender: UISwitch) {
        aesKetSize256 = sender.isOn
    }
}

