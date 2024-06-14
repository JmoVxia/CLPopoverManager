//
//  ViewController.swift
//  Demo
//
//  Created by Chen JmoVxia on 2022/11/7.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        CLPopoverManager.showSuccess()

        CLPopoverManager.showError(configCallback: { config in
            config.popoverMode = .queue
        }, strokeColor: .orange, text: "AAAA")

        CLPopoverManager.showError { config in
            config.popoverMode = .queue
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        CLPopoverManager.showSuccess()

        CLPopoverManager.showError(configCallback: { config in
            config.popoverMode = .queue
        }, strokeColor: .orange, text: "XXXXXX")
    }
}
