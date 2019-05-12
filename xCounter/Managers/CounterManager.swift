//
//  CounterManager.swift
//  xCounter
//
//  Created by Zahar on 12/05/2019.
//  Copyright © 2019 Zakhar Rudenko. All rights reserved.
//

import RealmSwift


internal class DBManager {
	private var database: Realm
	static let shared = DBManager()
	private init() {
		database = try! Realm()
	}
	
	func getDataFromDB() -> Results<Counter> {
		let results: Results<Counter> = database.objects(Counter.self)
		return results
	}
	
	func addData(object: Counter)   {
		try! database.write {
			database.add(object, update: true)
			print("Added new object")
		}
	}
	
	func deleteAllFromDatabase()  {
		try! database.write {
			database.deleteAll()
		}
	}
	
	func deleteFromDb(object: Counter)   {
		try! database.write {
			database.delete(object)
		}
	}
}

//internal class CounterManager {
//
//	static let shared = CounterManager()
//	private init() {}
//
//	func saveObject<T:Object>(object: T) {
//		let realm = try! Realm()
//		try! realm.write {
//			realm.add(object)
//		}
//	}
//
//	func getObjects<T:Object>()->[T] {
//		let realm = try! Realm()
//		let realmResults = realm.objects(T.self)
//		return Array(realmResults)
//
//	}
//
//	func getObjects<T:Object>(filter:String)->[T] {
//		let realm = try! Realm()
//		let realmResults = realm.objects(T.self).filter(filter)
//		return Array(realmResults)
//
//	}
//}
