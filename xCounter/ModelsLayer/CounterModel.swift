//
//  Counter.swift
//  xCounter
//
//  Created by Zahar on 12/05/2019.
//  Copyright © 2019 Zakhar Rudenko. All rights reserved.
//

import Foundation
import RealmSwift

class Counter: Object {
	@objc dynamic var created = 0
	@objc dynamic var name = ""
	@objc dynamic var count = 0
	
	override static func primaryKey() -> String? {
		return "name"
	}
}
