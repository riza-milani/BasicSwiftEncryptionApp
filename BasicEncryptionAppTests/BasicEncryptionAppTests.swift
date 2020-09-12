//
//  BasicEncryptionAppTests.swift
//  BasicEncryptionAppTests
//
//  Created by riza milani on 6/22/1399 AP.
//  Copyright © 1399 reza milani. All rights reserved.
//

import XCTest
@testable import BasicEncryptionApp

class BasicEncryptionAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEncrypionCBC256Successful() throws {
        let basicEncryption = BasicEncryption(mode: .cbc, size: .aes_256)
        let clearText = "sample text!"
        let clearTextData = clearText.data(using:String.Encoding.utf8)!
        let dictionary = basicEncryption.encrypt(clearTextData, withPassword: "123456")
        let decrypted = basicEncryption.decryp(fromDictionary: dictionary, withPassword: "123456")
        let decryptedString = String(data: decrypted, encoding: String.Encoding.utf8)
        XCTAssertEqual(clearText, decryptedString)
    }

    func testEncrypionCBC128Successful() throws {
        let basicEncryption = BasicEncryption(mode: .cbc, size: .aes_128)
        let clearText = "sample text!"
        let clearTextData = clearText.data(using:String.Encoding.utf8)!
        let dictionary = basicEncryption.encrypt(clearTextData, withPassword: "123456")
        let decrypted = basicEncryption.decryp(fromDictionary: dictionary, withPassword: "123456")
        let decryptedString = String(data: decrypted, encoding: String.Encoding.utf8)
        XCTAssertEqual(clearText, decryptedString)
    }

    func testEncrypionECB256Successful() throws {
        let basicEncryption = BasicEncryption(mode: .ecb, size: .aes_256)
        let clearText = "sample text!"
        let clearTextData = clearText.data(using:String.Encoding.utf8)!
        let dictionary = basicEncryption.encrypt(clearTextData, withPassword: "123456")
        let decrypted = basicEncryption.decryp(fromDictionary: dictionary, withPassword: "123456")
        let decryptedString = String(data: decrypted, encoding: String.Encoding.utf8)
        XCTAssertEqual(clearText, decryptedString)
    }

    func testEncrypionECB128Successful() throws {
        let basicEncryption = BasicEncryption(mode: .ecb, size: .aes_128)
        let clearText = "sample text!"
        let clearTextData = clearText.data(using:String.Encoding.utf8)!
        let dictionary = basicEncryption.encrypt(clearTextData, withPassword: "123456")
        let decrypted = basicEncryption.decryp(fromDictionary: dictionary, withPassword: "123456")
        let decryptedString = String(data: decrypted, encoding: String.Encoding.utf8)
        XCTAssertEqual(clearText, decryptedString)
    }

    func testEncrypionFailurWrongPassword() throws {
        let basicEncryption = BasicEncryption(mode: .cbc, size: .aes_256)
        let clearText = "sample text!"
        let clearTextData = clearText.data(using:String.Encoding.utf8)!
        let dictionary = basicEncryption.encrypt(clearTextData, withPassword: "1234561")
        let decrypted = basicEncryption.decryp(fromDictionary: dictionary, withPassword: "123456")
        let decryptedString = String(data: decrypted, encoding: String.Encoding.utf8)
        XCTAssertFalse(clearText == decryptedString)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
