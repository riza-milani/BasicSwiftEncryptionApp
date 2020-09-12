//
//  DetailViewModel.swift
//  BasicEncryptionApp
//
//  Created by riza milani on 6/22/1399 AP.
//  Copyright © 1399 reza milani. All rights reserved.
//

import Foundation

class DetailViewModel {

    let serviceCall: ServiceCall

    init(urlLink: String?, aesCBCMode: Bool, aesSize256: Bool) {
        let mode = aesCBCMode == true ? BasicEncryption.EncryptionMode.cbc : BasicEncryption.EncryptionMode.ecb
        let size = aesSize256 == true ? BasicEncryption.EncryptionKeySize.aes_256 : BasicEncryption.EncryptionKeySize.aes_128
        if let urlLink = urlLink, !urlLink.isEmpty {
            serviceCall = ServiceCallApi(urlLink: urlLink, aesMode: mode, aesSize: size)
        } else {
            serviceCall = ServiceCallLocal(aesMode: mode, aesSize: size)
        }
        
    }
    func decrypt(password: String?, completion: @escaping(((String) -> Void))) {
        guard let passwordText = password, !passwordText.isEmpty else {
            completion("please enter the decryption password")
            return
        }
        serviceCall.fetchData(decryptionPassword: passwordText) { (resutl: Result<Respond, Error>) in
            DispatchQueue.main.async {
                switch resutl {
                case .success(let respond) :
                    completion(respond.result)
                case .failure(let error):
                    completion(error.localizedDescription)
                }
            }
        }
    }
}
