//
//  File.swift
//  myPwdApp
//
//  Created by Adam Poustka on 2021-03-28.
//

import Foundation
import CryptoKit

// -- One possibility how to solve problem with decryption, works in playground, just need to figure out how to implement it here --
//let key = SymmetricKey(size: .bits256)
//let savedKey = key.withUnsafeBytes {Data(Array($0)).base64EncodedString()}
//
//if let keyData = Data(base64Encoded: savedKey) {
//    let retrievedKey = SymmetricKey(data: keyData)
//}

// Class that cares for encrypting and decrypting passwords that are stored in Firebase
class CryptoManager {
    // Creating SymmetricKey
    let key256 = SymmetricKey(size: .bits256)
    
    // Function that encrypts password using ChaChaPoly cipher and SymmetricKey
    func encrypt(password: String) -> Data {
        let passwordAsData = password.data(using: .utf8)
        let sealedBoxData = try! ChaChaPoly.seal(passwordAsData!, using: key256).combined
        print(key256)
        return sealedBoxData
      
    }
    
    // Function that decrypts password using ChaChaPoly cipher and SymmetricKey
    func decrypt(sealedBoxData: Data) -> String {
        let sealedBox = try! ChaChaPoly.SealedBox(combined: sealedBoxData)
        print(key256)
        let decryptedPassword = try! ChaChaPoly.open(sealedBox, using: key256)
        let pwdAsString = String(data: decryptedPassword, encoding: .utf8)!
        
        return pwdAsString
    }
}
