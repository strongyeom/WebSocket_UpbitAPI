//
//  SwiftViewController.swift
//  WebSocket_UpbitAPI
//
//  Created by 염성필 on 2023/12/27.
//

import UIKit

let age = Int.random(in: 1...100)
var status = false
class SwiftViewController: UIViewController {
    
    // 상수에 조건문을 담을 수 있음 -> 장점 : 메서드를 따로 만들지 않아도 됨
//    let newResult = if age < 30 { "학생입니다" } else if age > 31 && age < 60 { "어른입니다" } else { "노인입니다"}
//
//    let userStatus = if status { UIColor.black } else { UIColor.red }
//
//    let newResultSwitch = switch age {
//                            case 1...30: return "학생입니다"
//                            case 31...60: return "어른입니다"
//                            case 61...100: return "노인입니다"
//                            default: return "알 수 없어요"
//                            }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        exampleGeneric(a: 3, 4)
//        let result = exampleGeneric(a: 3, 4, 5, 6, 7)
//        result.4
//
//        exampleGeneric(a: 3, 4, 5, 6, 7, 4, ,5, 12)
        
    }
    
    func example<T, K>(a: T, b: K) -> String {
        return "\(a), \(b)"
    }
    
    // each:  T를 쓰긴 할건데 갯수에 대한 제한을 없애줌
//    func exampleGeneric<each T>(a: repeat (each T)) =? (repeat each T) {
//        return (repeat each a)
//    }
    
    func randomAge() -> String {
        
        switch age {
        case 1...30: return "학생입니다"
        case 31...60: return "어른입니다"
        case 61...100: return "노인입니다"
        default: return "알 수 없어요"
        }
    }
    
    func randomAge2() -> String {
        
        if age < 30 {
            return "학생입니다"
        } else if age > 31 && age < 60 {
            return "어른입니다"
        } else {
            return "노인입니다"
        }
    }
    

    
    
}
