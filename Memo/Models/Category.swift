//
//  Category.swift
//  Memo
//
//  Created by Darius Turner on 7/30/19.
//  Copyright © 2019 Darius Turner. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let memos = List<Memo>()
}
