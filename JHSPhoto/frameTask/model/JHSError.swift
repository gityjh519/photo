//
//  JHSError.swift
//  JHSPhoto
//
//  Created by yaojinhai on 2019/3/12.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit

class JHSError: Error{

    var code: Int
    var description: String
    init(code: Int,description: String) {
        self.code = code;
        self.description = description;
    }
}
