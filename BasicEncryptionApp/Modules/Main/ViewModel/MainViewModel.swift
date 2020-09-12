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

    func showDetailView() {
        let detailViewController = DetailViewController()
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
