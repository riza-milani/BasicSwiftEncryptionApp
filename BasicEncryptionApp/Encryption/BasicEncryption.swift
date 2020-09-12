//
//  BasicEncryption.swift
//  BasicEncryptionApp
//
//  Created by riza milani on 6/22/1399 AP.
//  Copyright © 1399 reza milani. All rights reserved.
//  Reference: https://code.tutsplus.com/tutorials/securing-ios-data-at-rest-encryption--cms-28786
//

import Foundation
import CommonCrypto

class BasicEncryption {

    enum EncryptionMode {
        case cbc
        case ecb
        var value: UInt32 {
            switch self {
            case .ecb:
                return UInt32(kCCOptionECBMode + kCCOptionPKCS7Padding)
            case .cbc:
                return UInt32(kCCOptionPKCS7Padding)
            }
        }
    }

    enum EncryptionKeySize {
        case aes_128
        case aes_256
        var value: Int {
            switch self {
            case .aes_128:
                return kCCKeySizeAES128
            case .aes_256:
                return kCCKeySizeAES256
            }
        }
    }

    let encryptionMode: EncryptionMode
    let encryptionKeySize: EncryptionKeySize
    
    init(mode: EncryptionMode, size: EncryptionKeySize) {
        encryptionMode = mode
        encryptionKeySize = size
    }

    convenience init() {
        self.init(mode:EncryptionMode.cbc, size: EncryptionKeySize.aes_256)
    }

    func encrypt(_ clearTextData : Data, withPassword password : String) -> Dictionary<String, Data> {
        var setupSuccess = true
        var outDictionary = Dictionary<String, Data>.init()
        var key = Data(repeating:0, count: encryptionKeySize.value)
        var salt = Data(count: 8)
        let saltCount = salt.count
        let keyCount = key.count

        salt.withUnsafeMutableBytes { (saltBytes: UnsafeMutablePointer<UInt8>) -> Void in
            let saltStatus = SecRandomCopyBytes(kSecRandomDefault, saltCount, saltBytes)
            if saltStatus == errSecSuccess
            {
                let passwordData = password.data(using:String.Encoding.utf8)!
                key.withUnsafeMutableBytes { (keyBytes : UnsafeMutablePointer<UInt8>) in
                    let derivationStatus = CCKeyDerivationPBKDF(
                        CCPBKDFAlgorithm(kCCPBKDF2),
                        password,
                        passwordData.count,
                        saltBytes,
                        saltCount,
                        CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA512),
                        14270,
                        keyBytes,
                        keyCount)
                    if derivationStatus != Int32(kCCSuccess)
                    {
                        setupSuccess = false
                    }
                }
            }
            else
            {
                setupSuccess = false
            }
        }
        
        var iv = Data.init(count: kCCBlockSizeAES128)
        iv.withUnsafeMutableBytes { (ivBytes : UnsafeMutablePointer<UInt8>) in
            
            let ivStatus = SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, ivBytes)
            if ivStatus != errSecSuccess
            {
                setupSuccess = false
            }
        }
        
        if (setupSuccess)
        {
            var numberOfBytesEncrypted : size_t = 0
            let size = clearTextData.count + kCCBlockSizeAES128
            var encrypted = Data.init(count: size)
            let cryptStatus = iv.withUnsafeBytes {ivBytes in
                encrypted.withUnsafeMutableBytes {encryptedBytes in
                clearTextData.withUnsafeBytes {clearTextBytes in
                    key.withUnsafeBytes {keyBytes in
                        CCCrypt(CCOperation(kCCEncrypt),
                                CCAlgorithm(kCCAlgorithmAES),
                                encryptionMode.value,
                                keyBytes,
                                key.count,
                                ivBytes,
                                clearTextBytes,
                                clearTextData.count,
                                encryptedBytes,
                                size,
                                &numberOfBytesEncrypted)
                        }
                    }
                }
            }
            if cryptStatus == Int32(kCCSuccess)
            {
                encrypted.count = numberOfBytesEncrypted
                outDictionary["EncryptionData"] = encrypted
                outDictionary["EncryptionIV"] = iv
                outDictionary["EncryptionSalt"] = salt
            }
        }

        return outDictionary;
    }

    func decryp(fromDictionary dictionary : Dictionary<String, Data>, withPassword password : String) -> Data
    {
        var setupSuccess = true
        let encrypted = dictionary["EncryptionData"]
        let iv = dictionary["EncryptionIV"]
        let salt = dictionary["EncryptionSalt"]
        var key = Data(repeating:0, count: encryptionKeySize.value)
        let keyCount = key.count
        salt?.withUnsafeBytes { (saltBytes: UnsafePointer<UInt8>) -> Void in
            let passwordData = password.data(using:String.Encoding.utf8)!
            key.withUnsafeMutableBytes { (keyBytes : UnsafeMutablePointer<UInt8>) in
                let derivationStatus = CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    password,
                    passwordData.count,
                    saltBytes,
                    salt!.count,
                    CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA512),
                    14270,
                    keyBytes,
                    keyCount)
                if derivationStatus != Int32(kCCSuccess)
                {
                    setupSuccess = false
                }
            }
        }
         
        var decryptSuccess = false
        let size = (encrypted?.count)! + kCCBlockSizeAES128
        var clearTextData = Data.init(count: size)
        if (setupSuccess)
        {
            var numberOfBytesDecrypted : size_t = 0
            let cryptStatus = iv?.withUnsafeBytes {ivBytes in
                clearTextData.withUnsafeMutableBytes {clearTextBytes in
                encrypted?.withUnsafeBytes {encryptedBytes in
                    key.withUnsafeBytes {keyBytes in
                        CCCrypt(CCOperation(kCCDecrypt),
                                CCAlgorithm(kCCAlgorithmAES128),
                                encryptionMode.value,
                                keyBytes,
                                key.count,
                                ivBytes,
                                encryptedBytes,
                                (encrypted?.count)!,
                                clearTextBytes,
                                size,
                                &numberOfBytesDecrypted)
                        }
                    }
                }
            }
            if cryptStatus! == Int32(kCCSuccess)
            {
                clearTextData.count = numberOfBytesDecrypted
                decryptSuccess = true
            }
        }
         
        return decryptSuccess ? clearTextData : Data.init(count: 0)
    }
}

