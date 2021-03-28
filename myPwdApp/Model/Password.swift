//
//  File.swift
//  myPwdApp
//
//  Created by Adam Poustka on 2021-03-28.
//

import Foundation
import CryptoKit

//  Password structure
struct Password {
    let title: String
    let pwd: Data
    
    let cm = CryptoManager()
    
    // Computed variable of decrypted password.
    
    // --!!-- Here it crashes, needs to be resolved
    var decryptedPassword: String {
//        return cm.decrypt(sealedBoxData: pwd)
        return "0"
    }
}
