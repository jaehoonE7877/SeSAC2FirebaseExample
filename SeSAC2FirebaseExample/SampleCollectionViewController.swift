//
//  SampleCollectionViewController.swift
//  SeSAC2FirebaseExample
//
//  Created by Seo Jae Hoon on 2022/10/18.
//

import UIKit

import RealmSwift

class SampleCollectionViewController: UICollectionViewController {

    var tasks: Results<Todo>! {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    let localRealm = try! Realm()
    //한 cell에 대한 타입
    var cellRegisteration: UICollectionView.CellRegistration<UICollectionViewListCell, Todo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = localRealm.objects(Todo.self)
        
        collectionViewConfig()
    }
    
    private func collectionViewConfig() {
        
        let configuratration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuratration)
        // UICollectionViewCompositionalLayout
        collectionView.collectionViewLayout = layout //UICollectionViewLayout
        
        cellRegisteration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            
            var content = cell.defaultContentConfiguration() //UIListContnetConfiguration(구조체) -> 프로토콜
            
            content.image = itemIdentifier.importance < 3 ? UIImage(systemName: "person.2.fill") : UIImage(systemName: "star.fill")
            
            content.text = itemIdentifier.title
            content.secondaryText = "\(itemIdentifier.detail.count)개의 세부 항목"
            
            cell.contentConfiguration = content //UIContentConfiguration -> 프로토콜 타입을 프로퍼티로 갖고 있음 => UiListContentConfig -> 프로토콜을 채택한 구조체
            
        })
        
    }

}

extension SampleCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = tasks[indexPath.item]
        
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: item)
        
//        var test: Fruit = Apple()
//        test = Banana()
//        test = Melon()
        return cell
    }
    
}

class Food {
    
}

protocol Fruit {
    
}

class Apple: Food, Fruit {
    
}

class Banana: Food, Fruit {
    
}

enum Strawberry: Fruit{
    
}

struct Melon: Fruit {
    
}
