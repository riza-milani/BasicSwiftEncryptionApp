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
    func fetchData(completion: @escaping ((Result<ResponseData, Error>) -> Void))
}

class ServiceCallApi: ServiceCall {
    func fetchData(completion: @escaping ((Result<ResponseData, Error>) -> Void)) {
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
                guard let responseData = try? JSONDecoder().decode(ResponseData.self, from: dataResponse) else {
                    completion(.failure(NSError(domain: "Can not decode the data.", code: 0, userInfo: nil)))
                    return
                }
                completion(.success(responseData))
            }
            task.resume()
        }
    }
}
