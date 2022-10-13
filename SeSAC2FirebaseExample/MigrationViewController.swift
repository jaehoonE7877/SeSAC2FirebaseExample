//
//  MigrationViewController.swift
//  SeSAC2FirebaseExample
//
//  Created by Seo Jae Hoon on 2022/10/13.
//

import UIKit

import RealmSwift
class MigrationViewController: UIViewController {
    
    let localRealm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. fileURL
        print("FILE URL: \(localRealm.configuration.fileURL!)")
        
        //2. Schemaversion
        do {
            let version = try schemaVersionAtURL(localRealm.configuration.fileURL!)
            print("Schema Version: \(version)")
        } catch let error {
            print(error)
        }
        
        //3. Test
        for i in 1...100 {
            
            let task = Todo(title: "고래밥 먹기\(i)", importance: Int.random(in: 1...5))
            
            try! localRealm.write{
                localRealm.add(task)
            }
            
        }
        
    }
    
}
