//
//  CLPopoverManager+Extension.swift
//  CL
//
//  Created by Chen JmoVxia on 2022/11/4.
//  Copyright © 2022 JmoVxia. All rights reserved.
//

import Foundation
import UIKit

extension CLPopoverManager {
    /// 显示成功
    class func showSuccess(configCallback: ((CLPopoverConfig) -> Void)? = nil,
                           strokeColor: UIColor = .red,
                           text: String? = nil,
                           dismissDuration: CGFloat = 1.0,
                           dismissCallback: (() -> Void)? = nil)
    {
        mainSync {
            let controller = CLPopoverHudController()
            configCallback?(controller.config)
            controller.animationType = .success
            controller.strokeColor = strokeColor
            controller.text = text
            controller.dismissDuration = dismissDuration
            controller.dismissCallback = dismissCallback
            CLPopoverManager.show(controller)
        }
    }

    /// 显示错误
    class func showError(configCallback: ((CLPopoverConfig) -> Void)? = nil,
                         strokeColor: UIColor = .red,
                         text: String? = nil,
                         dismissDuration: CGFloat = 1.0,
                         dismissCallback: (() -> Void)? = nil)
    {
        mainSync {
            let controller = CLPopoverHudController()
            configCallback?(controller.config)
            controller.animationType = .error
            controller.strokeColor = strokeColor
            controller.text = text
            controller.dismissDuration = dismissDuration
            controller.dismissCallback = dismissCallback
            CLPopoverManager.show(controller)
        }
    }
}
