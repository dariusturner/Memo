//
//  Memo.swift
//  Memo
//
//  Created by Darius Turner on 7/30/19.
//  Copyright © 2019 Darius Turner. All rights reserved.
//

import Foundation
import RealmSwift

class Memo: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "memos")
}
