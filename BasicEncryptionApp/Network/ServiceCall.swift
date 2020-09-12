//
//  ServiceCall.swift
//  BasicEncryptionApp
//
//  Created by riza milani on 6/22/1399 AP.
//  Copyright © 1399 reza milani. All rights reserved.
//

import Foundation

typealias ResponseData = String
let baseUrl = "http://service-address-com/sample.json"

protocol ServiceCall {
    func fetchData<T: Decodable>(completion: @escaping ((Result<T, Error>) -> Void))
}

class ServiceCallApi: ServiceCall {
    func fetchData<T: Decodable>(completion: @escaping ((Result<T, Error>) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            let endpoint: String = baseUrl
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
                guard let responseData = try? JSONDecoder().decode(T.self, from: dataResponse) else {
                    completion(.failure(NSError(domain: "Can not decode the data.", code: 0, userInfo: nil)))
                    return
                }
                completion(.success(responseData))
            }
            task.resume()
        }
    }
}

class ServiceCallLocal: ServiceCall {

    let basicEncryption = BasicEncryption()

    func mockEncryptionData() -> Data? {
        if let data = "{ \"result\": \"This is simple test\"}".data(using: .utf8) {
            let result = self.basicEncryption.encrypt(data, withPassword: "12345")
            return try? JSONEncoder().encode(result)
        }
        return nil
    }

    func fetchData<T: Decodable>(completion: @escaping ((Result<T, Error>) -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async {

            if let data = self.mockEncryptionData() {
                guard let responseData = try? JSONDecoder().decode(T.self, from: data) else {
                    completion(.failure(NSError(domain: "Can not decode the data.", code: 0, userInfo: nil)))
                    return
                }
                completion(.success(responseData))
            }
        }
    }
}
