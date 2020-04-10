//
//  ViewController.swift
//  DW_ToolDemo
//
//  Created by mrLiu on 2020/4/10.
//  Copyright © 2020 泰恵天润. All rights reserved.
//

import UIKit
import DW_Tool

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let textF = UITextField()
        let string = textF.DW_text

        print(string)

        let button = UIButton()
        let btnStr = button.DW_text



    }


}
//extension NoNilStringType where self : UITextField {
//    func 
//}

