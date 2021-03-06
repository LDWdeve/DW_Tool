//
//  DW_OriginTool.swift
//  DW_ToolDemo
//
//  Created by mrLiu on 2020/4/10.
//  Copyright © 2020 LDW. All rights reserved.
//

///UITextField\UITextView\UIButton 添加DW_text计算属性，获取拆包后的字符串

import UIKit

///
public protocol NoNilStringType {
//    associatedtype E
    func noNilText() -> String
    var DW_text:String{ get }
}

extension NoNilStringType where Self : UITextField {

    public func noNilText() -> String {
        guard let string = self.text else {

            return ""
        }
        return string
    }
}

extension NoNilStringType where Self : UITextView {

    public func noNilText() -> String {
        guard let string = self.text else {

            return ""
        }
        return string
    }
}

extension NoNilStringType where Self : UIButton {

    public func noNilText() -> String {
        guard let string = self.currentTitle else {

            return ""
        }
        return string
    }
}

extension UITextField:NoNilStringType{
    public var DW_text: String {
        get {
            self.noNilText()
        }
    }
}

extension UITextView:NoNilStringType{
    public var DW_text: String {
        get {
            self.noNilText()
        }
    }
}

extension UIButton:NoNilStringType{
    public var DW_text: String {
        get {
            self.noNilText()
        }
    }
}


