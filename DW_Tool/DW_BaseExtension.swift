//
//  DW_BaseExtension.swift
//  DW_Tool
//
//  Created by mrLiu on 2020/4/10.
//


public extension String {
    
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    func mySubString(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }

    func getNumString() -> String {
        if self.count == 0 {
            return "0"
        }

           return self
       }

     func getNum() -> Double {

           if self.count > 0 {
               if let num = Double(self) {
                   return num
               }
               return 0
           }

           return 0

       }
}

public extension Dictionary {
    func numberForKey(_ key: String) -> Double{

        if let dic =  self as? [String:Any]{

            let obj = dic[key]

            if obj is NSNull{

                return 0

            }else if obj is NSNumber{

                let num = obj as! NSNumber
                return num.doubleValue
            }else if obj is String{

                if let num = Double(obj as! String) {
                    return num
                }
                return 0
            }
            return 0
        }

        return 0
    }

    func stringForKey(_ key: String) -> String{

        if let dic =  self as? [String:Any]{

            let obj = dic[key]

            if obj is NSNull{

                return ""

            }else if obj is NSNumber{

                let num = obj as! NSNumber
                return num.stringValue
            }
            return (obj ?? "") as! String
        }

        return ""

    }
}

///进入app设置界面
//public func openApplicationSettingUI(){
//
//    let url = URL.init(string: UIApplication.openSettingsURLString)
//
//    if UIApplication.shared.canOpenURL(url!) {
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(url!, options:[:], completionHandler: nil)
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//}
