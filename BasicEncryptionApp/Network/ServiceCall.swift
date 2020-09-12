//
//  ServiceCall.swift
//  BasicEncryptionApp
//
//  Created by riza milani on 6/22/1399 AP.
//  Copyright © 1399 reza milani. All rights reserved.
//

import Foundation

typealias ResponseData = String

protocol ServiceCall {
    func fetchData<T: Decodable>(decryptionPassword: String, completion: @escaping ((Result<T, Error>) -> Void))
}

class ServiceCallApi: ServiceCall {

    let basicEncryption: BasicEncryption
    let urlLink: String

    init(urlLink: String, aesMode: BasicEncryption.EncryptionMode, aesSize: BasicEncryption.EncryptionKeySize) {
        self.urlLink = urlLink
        basicEncryption = BasicEncryption(mode: aesMode, size: aesSize)
    }

    func fetchData<T: Decodable>(decryptionPassword: String, completion: @escaping ((Result<T, Error>) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            let endpoint: String = self.urlLink
            guard let url = URL(string: endpoint) else {
                completion(.failure(NSError(domain: "Can not create url address.", code: 0, userInfo: nil)))
                return
            }
            let urlRequest = URLRequest(url: url)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: urlRequest) { (data, response, error) in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                guard let dataResponse = data else {
                    completion(.failure(NSError(domain: "There is no data response.", code: 0, userInfo: nil)))
                    return
                }
                guard let responseData = try? JSONDecoder().decode([String: Data].self, from: dataResponse) else {
                    completion(.failure(NSError(domain: "Can not decode the data.", code: 0, userInfo: nil)))
                    return
                }
                let decryptedData = self.basicEncryption.decryp(fromDictionary: responseData, withPassword: decryptionPassword)
                guard let decryptedResponse = try? JSONDecoder().decode(T.self, from: decryptedData) else {
                    completion(.failure(NSError(domain: "Can not decode the data.", code: 0, userInfo: nil)))
                    return
                }
                completion(.success(decryptedResponse))
            }
            task.resume()
        }
    }
}

class ServiceCallLocal: ServiceCall {

    let basicEncryption: BasicEncryption

    init(aesMode: BasicEncryption.EncryptionMode, aesSize: BasicEncryption.EncryptionKeySize) {
        basicEncryption = BasicEncryption(mode: aesMode, size: aesSize)
    }

    func mockEncryptionData() -> Data? {
        if let data = "{ \"result\": \"This is simple test\"}".data(using: .utf8) {
            let result = self.basicEncryption.encrypt(data, withPassword: "12345")
            return try? JSONEncoder().encode(result)
        }
        return nil
    }

    func fetchData<T: Decodable>(decryptionPassword: String, completion: @escaping ((Result<T, Error>) -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async {

            if let data = self.mockEncryptionData() {
                guard let responseData = try? JSONDecoder().decode([String: Data].self, from: data) else {
                    completion(.failure(NSError(domain: "Can not decode the data.", code: 0, userInfo: nil)))
                    return
                }
                let decryptedData = self.basicEncryption.decryp(fromDictionary: responseData, withPassword: decryptionPassword)
                guard let decryptedResponse = try? JSONDecoder().decode(T.self, from: decryptedData) else {
                    completion(.failure(NSError(domain: "Can not decode the data.", code: 0, userInfo: nil)))
                    return
                }
                completion(.success(decryptedResponse))
            }
        }
    }
}
