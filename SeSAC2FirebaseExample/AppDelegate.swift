//
//  AppDelegate.swift
//  SeSAC2FirebaseExample
//
//  Created by Seo Jae Hoon on 2022/10/05.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIViewController.swizzleMethod() // 
        
        FirebaseApp.configure()
        
        //원격 알림 시스템에 앱을 등록
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        //메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        //현재 등록된 토큰 가져오기 -> 회원탈퇴했을 때
//        Messaging.messaging().token { token, error in
//          if let error = error {
//            print("Error fetching FCM registration token: \(error)")
//          } else if let token = token {
//            print("FCM registration token: \(token)")
//          }
//        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
// 72 ~ 96 있어도 되고 없어도 되는 부분이지만,
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    //포그라운드 알림 수신: 로컬/ 푸시 동일
    // 일정 화면에서는 노티를 띄우고 싶지 않을 때, 만약 카카오톡 채팅화면에 있을 때,
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       
        //최상단 뷰컨트롤러에 따라서 노티를 줄지 말지 결정! -> 채팅앱 같은 경우에는 많이 사용 됨
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        
        if viewController is SettingViewController {
            completionHandler([.badge, .list])
        } else {
            //.banner, .list: iOS14+
            completionHandler([.badge, .sound, .banner, .list])
        }

    }
    // 유저가 푸시를 클릭했을 때만 수신 확인 가능
    
    // 특정 푸시를 클릭하면 특정 상세화면으로 화면 전환 > 
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        print("사용자가 푸시를 클릭했습니다.")
        
        print(response.notification.request.content.body) // 알림 메시지의 내용을 출력할 수 있음
        
        print(response.notification.request.content.userInfo)
        
        let userInfo = response.notification.request.content.userInfo
        
        if userInfo[AnyHashable("sesac")] as? String == "project" {
            //원하는 화면으로 전환하기
            print("SESAC PROJECT")
        } else {
            print("NOTHING")
        }
     
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        
        print(viewController)
        
        if viewController is ViewController {   // 최상단 화면이 Viewcontroller 클래스 인스턴스로 타입캐스팅이 가능하다면 실행
            viewController.navigationController?.pushViewController(SettingViewController(), animated: true)
        } else if viewController is ProfileViewController { // 상세 화면일 때 dismiss해주기
            viewController.dismiss(animated: true)
        } else if viewController is SettingViewController {
            viewController.navigationController?.popViewController(animated: true)
        }

    }
    
    
}

extension AppDelegate: MessagingDelegate {
    
    // 토큰 갱신 모니터링: 토큰 정보가 언제 바뀔까?
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
      // 토큰을 파베에 등록해서 전달!
      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

// 기기 -> APNS한테 토큰을 달라고 요청 -> 토큰을 받은 기기는 이 토큰을 서버(FireBase)에 전달해준다.
// 파베는 여기서 특정 유저(기기)에게 특정 푸쉬를 보낼 수 있게 이미 데이터를 갖고 있음!
