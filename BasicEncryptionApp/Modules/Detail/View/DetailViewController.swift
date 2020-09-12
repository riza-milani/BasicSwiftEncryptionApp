//
//  DetailViewController.swift
//  BasicEncryptionApp
//
//  Created by riza milani on 6/22/1399 AP.
//  Copyright © 1399 reza milani. All rights reserved.
//

import UIKit

struct Respond: Decodable {
    let result: String
}
class DetailViewController: UIViewController {

    var detailViewModel: DetailViewModel?

    @IBOutlet weak var decryptedContent: UILabel!
    @IBOutlet weak var password: UITextField!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    convenience init(urlLink: String?, aesCBCMode: Bool, aesKeySize256: Bool) {
        self.init(nibName:nil, bundle:nil)
        detailViewModel = DetailViewModel(urlLink: urlLink, aesCBCMode: aesCBCMode, aesSize256: aesKeySize256)
        
    }

    // This extends the superclass.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func decryptAction(_ sender: Any) {
        detailViewModel?.decrypt(password: password.text) { [weak self] result in
            self?.decryptedContent.text = result
        }
    }
}
