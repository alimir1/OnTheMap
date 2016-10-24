//
//  UdacityUser.swift
//  On The Map
//
//  Created by Ali Mir on 10/23/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

// MARK: - UdacityUser

struct UdacityUser {
    // MARK: Properties
    let accountID: Int
    let firstName: String
    let lastName: String
    
    init (firstName: String, lastName: String, accountID: Int) {
        self.accountID = accountID
        self.firstName = firstName
        self.lastName = lastName
    }
}
