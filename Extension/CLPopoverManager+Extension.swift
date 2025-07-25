//
//  CLPopoverManager+Extension.swift
//  CL
//
//  Created by Chen JmoVxia on 2022/11/4.
//  Copyright © 2022 JmoVxia. All rights reserved.
//

import DateToolsSwift
import Foundation
import UIKit

extension CLPopoverManager {
    /// 显示翻牌弹窗
    static func showFlop(configCallback: ((CLPopoverConfig) -> Void)? = nil) {
        let controller = CLPopupFlopController()
        configCallback?(controller.config)
        CLPopoverManager.show(controller)
    }

    /// 显示可拖拽弹窗
    static func showDrag(configCallback: ((CLPopoverConfig) -> Void)? = nil) {
        let controller = CLPopupMomentumController()
        configCallback?(controller.config)
        CLPopoverManager.show(controller)
    }

    /// 显示提示弹窗
    static func showTips(configCallback: ((CLPopoverConfig) -> Void)? = nil, text: String, dismissInterval: TimeInterval = 1.0, dissmissCallBack: (() -> Void)? = nil) {
        let controller = CLPopupTipsController()
        configCallback?(controller.config)
        controller.text = text
        controller.dismissInterval = dismissInterval
        controller.dissmissCallBack = dissmissCallBack
        CLPopoverManager.show(controller)
    }

    /// 显示一个消息弹窗
    static func showOneAlert(configCallback: ((CLPopoverConfig) -> Void)? = nil, title: String? = nil, message: String? = nil, sure: String = "确定", sureCallBack: (() -> Void)? = nil) {
        let controller = CLPopupMessageController()
        configCallback?(controller.config)
        controller.type = .one
        controller.titleLabel.text = title
        controller.messageLabel.text = message
        controller.sureButton.setTitle(sure, for: .normal)
        controller.sureButton.setTitle(sure, for: .selected)
        controller.sureButton.setTitle(sure, for: .highlighted)
        controller.sureCallBack = sureCallBack
        CLPopoverManager.show(controller)
    }

    /// 显示两个消息弹窗
    static func showTwoAlert(configCallback: ((CLPopoverConfig) -> Void)? = nil, title: String? = nil, message: String? = nil, left: String = "取消", right: String = "确定", leftCallBack: (() -> Void)? = nil, rightCallBack: (() -> Void)? = nil) {
        let controller = CLPopupMessageController()
        configCallback?(controller.config)
        controller.type = .two
        controller.titleLabel.text = title
        controller.messageLabel.text = message
        controller.leftButton.setTitle(left, for: .normal)
        controller.leftButton.setTitle(left, for: .selected)
        controller.leftButton.setTitle(left, for: .highlighted)
        controller.rightButton.setTitle(right, for: .normal)
        controller.rightButton.setTitle(right, for: .selected)
        controller.rightButton.setTitle(right, for: .highlighted)
        controller.leftCallBack = leftCallBack
        controller.rightCallBack = rightCallBack
        CLPopoverManager.show(controller)
    }

    /// 显示成功
    static func showSuccess(configCallback: ((CLPopoverConfig) -> Void)? = nil, strokeColor: UIColor = UIColor.red, text: String? = nil, dismissDuration: CGFloat = 1.0, dismissCallback: (() -> Void)? = nil) {
        let controller = CLPopoverHudController()
        configCallback?(controller.config)
        controller.animationType = .success
        controller.strokeColor = strokeColor
        controller.text = text
        controller.dismissDuration = dismissDuration
        controller.dismissCallback = dismissCallback
        CLPopoverManager.show(controller)
    }

    /// 显示错误
    static func showError(configCallback: ((CLPopoverConfig) -> Void)? = nil, strokeColor: UIColor = .red, text: String? = nil, dismissDuration: CGFloat = 1.0, dismissCallback: (() -> Void)? = nil) {
        let controller = CLPopoverHudController()
        configCallback?(controller.config)
        controller.animationType = .error
        controller.strokeColor = strokeColor
        controller.text = text
        controller.dismissDuration = dismissDuration
        controller.dismissCallback = dismissCallback
        CLPopoverManager.show(controller)
    }

    /// 显示加载动画
    static func showHudLoading(configCallback: ((CLPopoverConfig) -> Void)? = nil, strokeColor: UIColor = .red, text: String? = nil) {
        let controller = CLPopoverHudController()
        configCallback?(controller.config)
        controller.animationType = .loading
        controller.strokeColor = strokeColor
        controller.text = text
        controller.animationSize = CGSize(width: 80, height: 80)
        CLPopoverManager.show(controller)
    }

    /// 显示年月日选择器
    static func showYearMonthDayDataPicker(configCallback: ((CLPopoverConfig) -> Void)? = nil, minDate: Date = Date().subtract(TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 10)), maxDate: Date = Date(), yearMonthDayCallback: ((Int, Int, Int) -> Void)? = nil) {
        let controller = CLPopupDataPickerController()
        controller.minDate = minDate
        controller.maxDate = maxDate
        configCallback?(controller.config)
        controller.type = .yearMonthDay
        controller.yearMonthDayCallback = yearMonthDayCallback
        CLPopoverManager.show(controller)
    }

    /// 显示时分选择器
    static func showHourMinuteDataPicker(configCallback: ((CLPopoverConfig) -> Void)? = nil, hourMinuteCallback: ((Int, Int) -> Void)? = nil) {
        let controller = CLPopupDataPickerController()
        configCallback?(controller.config)
        controller.type = .hourMinute
        controller.hourMinuteCallback = hourMinuteCallback
        CLPopoverManager.show(controller)
    }

    /// 显示年月日时分选择器
    static func showYearMonthDayHourMinuteDataPicker(configCallback: ((CLPopoverConfig) -> Void)? = nil, yearMonthDayHourMinuteCallback: ((Int, Int, Int, Int, Int) -> Void)? = nil) {
        let controller = CLPopupDataPickerController()
        configCallback?(controller.config)
        controller.type = .yearMonthDayHourMinute
        controller.yearMonthDayHourMinuteCallback = yearMonthDayHourMinuteCallback
        CLPopoverManager.show(controller)
    }

    /// 显示时长选择器
    static func showDurationDataPicker(configCallback: ((CLPopoverConfig) -> Void)? = nil, durationCallback: ((String, String) -> Void)? = nil) {
        let controller = CLPopupDataPickerController()
        configCallback?(controller.config)
        controller.type = .duration
        controller.durationCallback = durationCallback
        CLPopoverManager.show(controller)
    }

    /// 显示一个选择器
    static func showOnePicker(configCallback: ((CLPopoverConfig) -> Void)? = nil, dataSource: [String], unit: String? = nil, space: CGFloat = -10, selectedCallback: ((String) -> Void)? = nil) {
        let controller = CLPopupDataPickerController()
        configCallback?(controller.config)
        controller.type = .one
        controller.unit = unit
        controller.space = space
        controller.dataSource = dataSource
        controller.selectedCallback = selectedCallback
        CLPopoverManager.show(controller)
    }

    /// 显示BMI输入弹窗
    static func showBMIInput(configCallback: ((CLPopoverConfig) -> Void)? = nil, bmiCallback: ((CGFloat) -> Void)? = nil) {
        let controller = CLPopupBMIInputController()
        configCallback?(controller.config)
        controller.bmiCallback = bmiCallback
        CLPopoverManager.show(controller)
    }

    /// 显示一个输入框弹窗
    static func showOneInput(configCallback: ((CLPopoverConfig) -> Void)? = nil, type: CLPopupOneInputType, sureCallback: ((String?) -> Void)? = nil) {
        let controller = CLPopupOneInputController()
        configCallback?(controller.config)
        controller.type = type
        controller.sureCallback = sureCallback
        CLPopoverManager.show(controller)
    }

    /// 显示两个输入框弹窗
    static func showTwoInput(configCallback: ((CLPopoverConfig) -> Void)? = nil, type: CLPopupTwoInputType, sureCallback: ((String?, String?) -> Void)? = nil) {
        let controller = CLPopupTwoInputController()
        configCallback?(controller.config)
        controller.type = type
        controller.sureCallback = sureCallback
        CLPopoverManager.show(controller)
    }

    /// 显示加载动画
    static func showLoading(configCallback: ((CLPopoverConfig) -> Void)? = nil) {
        let controller = CLPopoverLoadingController()
        configCallback?(controller.config)
        CLPopoverManager.show(controller)
    }
}

extension CLPopoverManager {
    static func showCalendar(configCallback: ((CLPopoverConfig) -> Void)? = nil) {
        let controller = CLPopupCalendarController()
        configCallback?(controller.config)
        CLPopoverManager.show(controller)
    }
}
