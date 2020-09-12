//
//  MainViewModel.swift
//  BasicEncryptionApp
//
//  Created by riza milani on 6/22/1399 AP.
//  Copyright © 1399 reza milani. All rights reserved.
//

import Foundation
import UIKit

class MainViewModel {

    var viewController: UIViewController?

    func showDetailView(url: String?, aesCBCMode: Bool, aesSize256: Bool) {
        let detailViewController = DetailViewController(urlLink: url, aesCBCMode: aesCBCMode, aesKeySize256: aesSize256)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
