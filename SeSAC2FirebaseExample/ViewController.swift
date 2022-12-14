//
//  ViewController.swift
//  SeSAC2FirebaseExample
//
//  Created by Seo Jae Hoon on 2022/10/05.
//

import UIKit
import FirebaseAnalytics

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        Analytics.logEvent("rejack", parameters: [
//          "name": "고래밥",
//          "full_text": "안녕하세요",
//        ])
//
//        Analytics.setDefaultEventParameters([
//          "level_name": "Caverns01",
//          "level_difficulty": 4
//        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("ViewController ViewWillAppear")
    }
    
    @IBAction func crashButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func profileButtonClicked(_ sender: UIButton) {
        present(ProfileViewController(),animated: true)
    }
    
    @IBAction func settingButtonClicked(_ sender: UIButton) {
        navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    
    
}


class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("ProfileViewController ViewWillAppear")
    }
}


class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("SettingViewController ViewWillAppear")
    }
    
}


extension UIViewController {
    
    var topViewController: UIViewController {
        return self.topViewController(currentViewController: self)
    }
    
    // 최상위 뷰컨트롤러를 판단해주는 메서드
    // 1. 탭바
    // 2. 네비게이션
    // 3. 둘 다 없을 때
    func topViewController(currentViewController: UIViewController) -> UIViewController {
        
        if let tabBarController = currentViewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            
            return self.topViewController(currentViewController: selectedViewController)
            
        } else if let navigationController = currentViewController as? UINavigationController,
                  let visibleViewController = navigationController.visibleViewController {
            
            return self.topViewController(currentViewController: visibleViewController)
            
        } else if let presentedViewController = currentViewController.presentedViewController {
            
            return self.topViewController(currentViewController: presentedViewController)
            
        } else {
            return currentViewController
        }
        

    }
    
}

//Method Swizzling
extension UIViewController {
    // 커뮤니케이션, 디버깅할 때 원하는 함수로 바꿔주는
    // class와 static의 차이 -> 상속 받아서 메서드를 override할 때
    // 구조체 싱글턴, 클래스 싱글턴 차이 => 찾아보기
    class func swizzleMethod() {
        
        let origin = #selector(viewWillAppear)
        let change = #selector(changeViewWillAppear)
        
        guard let originMethod = class_getInstanceMethod(UIViewController.self, origin), let changedMethod = class_getInstanceMethod(UIViewController.self, change) else
        {
            print("함수를 찾을 수 없거나 오류 발생")
            return
            
        }
        
        method_exchangeImplementations(originMethod, changedMethod)
            
    }
    
    @objc func changeViewWillAppear() {
        print("Change ViewWillAppear SUCCEED")
    }
    
}
