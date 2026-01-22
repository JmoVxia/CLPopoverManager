//
//  CLPopupController.swift
//  CLDemo
//
//  Created by JmoVxia on 2019/12/28.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit

class CLPopupModel: NSObject {
    var title: String?
    var callback: (() -> Void)?
}

class CLPopupController: UIViewController {
    lazy var arrayDS: [CLPopupModel] = {
        let arrayDS = [CLPopupModel]()
        return arrayDS
    }()

    lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        tableview.dataSource = self
        tableview.delegate = self
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 60
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        initData()
    }
}

extension CLPopupController {
    func initData() {
        // 混合模式测试案例
        do {
            let model = CLPopupModel()
            model.title = "【测试1】queue模式 - 预期:A→B→C依次显示"
            model.callback = { [weak self] in
                self?.test1_QueueMode()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试2】interrupt模式 - 预期:3个弹窗重叠显示"
            model.callback = { [weak self] in
                self?.test2_InterruptMode()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试3】suspend模式 - 预期:B挂起A,关闭B后A恢复"
            model.callback = { [weak self] in
                self?.test3_SuspendMode()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试4】replaceInheritSuspend - 预期:B替换A,关闭B后无弹窗"
            model.callback = { [weak self] in
                self?.test4_ReplaceInheritSuspendMode()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试5】replaceClearSuspend - 预期:B替换A,关闭B后无弹窗"
            model.callback = { [weak self] in
                self?.test5_ReplaceClearSuspendMode()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试6】replaceAll模式 - 预期:只显示C,A和B被清除"
            model.callback = { [weak self] in
                self?.test6_ReplaceAllMode()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试7】unique模式 - 预期:只显示A,B和C被阻止"
            model.callback = { [weak self] in
                self?.test7_UniqueMode()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试8】优先级测试 - 预期:关闭A后按High→Medium→Low顺序"
            model.callback = { [weak self] in
                self?.test8_PriorityQueue()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试9】queue+interrupt混合 - 预期:A和C重叠,关闭A后B显示"
            model.callback = { [weak self] in
                self?.test9_QueueWithInterrupt()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试10】queue+suspend混合 - 预期:C挂起A,关闭C后A恢复,关闭A后B显示"
            model.callback = { [weak self] in
                self?.test10_QueueWithSuspend()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试11】interrupt+suspend混合 - 预期:A和B重叠,C挂起两者,关闭C后A和B恢复"
            model.callback = { [weak self] in
                self?.test11_InterruptWithSuspend()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试12】suspend嵌套 - 预期:C→B→A依次恢复"
            model.callback = { [weak self] in
                self?.test12_NestedSuspend()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试13】继承挂起链 - 预期:C替换B,关闭C后A恢复(证明继承)"
            model.callback = { [weak self] in
                self?.test13_InheritSuspendChain()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试14】清除挂起链 - 预期:C替换B,关闭C后无弹窗(证明清除)"
            model.callback = { [weak self] in
                self?.test14_ClearSuspendChain()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试15】replaceAll清除所有 - 预期:只显示D,A/B/C都被清除"
            model.callback = { [weak self] in
                self?.test15_ReplaceAllClearEverything()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试16】unique阻止后续 - 预期:B替换A,C和D被阻止"
            model.callback = { [weak self] in
                self?.test16_UniqueBlockSubsequent()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试17】复杂场景1 - 预期:D挂起A,关闭D后A恢复,关闭A后C→B依次显示"
            model.callback = { [weak self] in
                self?.test17_ComplexMix1()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试18】复杂场景2 - 预期:D替换C,关闭D后B恢复,关闭B后A恢复"
            model.callback = { [weak self] in
                self?.test18_ComplexMix2()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试19】复杂场景3 - 预期:D挂起A和C,关闭D后A和C恢复,关闭A后B→E依次显示"
            model.callback = { [weak self] in
                self?.test19_ComplexMix3()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试20】identifier去重 - 预期:只显示A,B和C被去重,关闭A后D显示"
            model.callback = { [weak self] in
                self?.test20_IdentifierDeduplication()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试21】自定义导航控制器+suspend - 预期:B挂起A,push到C后关闭B,A恢复"
            model.callback = { [weak self] in
                self?.test21_NavigationControllerWithSuspend()
            }
            arrayDS.append(model)
        }

        // 原有示例
        do {
            let model = CLPopupModel()
            model.title = "翻牌弹窗(多次调用去重)"
            model.callback = { [weak self] in
                self?.showFlop()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "日历弹窗(排队)"
            model.callback = { [weak self] in
                self?.showCalendar()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "可拖拽弹窗(重叠-挂起)"
            model.callback = { [weak self] in
                self?.showDragView()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "一个按钮(惟一,移除之前,阻止后续弹窗)"
            model.callback = { [weak self] in
                self?.showOneAlert()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "两个按钮(替换之前的所有弹窗,但是不会移除排队的,也不会阻止之后的)"
            model.callback = { [weak self] in
                self?.showTwoAlert()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "加载弹窗(替换之前的所有弹窗,会移除排队的,但是不会阻止之后的)"
            model.callback = { [weak self] in
                self?.showLoading()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "成功弹窗"
            model.callback = { [weak self] in
                self?.showSuccess()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "错误弹窗"
            model.callback = { [weak self] in
                self?.showError()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "提示弹窗"
            model.callback = { [weak self] in
                self?.showTips()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "年月日选择"
            model.callback = { [weak self] in
                self?.showYearMonthDayDataPicker()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "时分选择"
            model.callback = { [weak self] in
                self?.showHourMinuteDataPicker()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "年月日时分选择"
            model.callback = { [weak self] in
                self?.showYearMonthDayHourMinuteDataPicker()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "BMI计算"
            model.callback = { [weak self] in
                self?.showBMIInput()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "一个输入框"
            model.callback = { [weak self] in
                self?.showOneInput()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "两个输入框"
            model.callback = { [weak self] in
                self?.showTwoInput()
            }
            arrayDS.append(model)
        }
    }
}

extension CLPopupController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayDS.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = arrayDS[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

extension CLPopupController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = arrayDS[indexPath.row]
        model.callback?()
    }
}

extension CLPopupController {
    func showFlop() {
        let controller = CLPopupFlopController()
        controller.config.popoverMode = .interrupt
        CLPopoverManager.show(controller)
        CLPopoverManager.show(controller)
        CLPopoverManager.show(controller)
        CLPopoverManager.show(controller)
        CLPopoverManager.show(controller)
        CLPopoverManager.show(controller)
    }

    func showCalendar() {
        CLPopoverManager.showCalendar()
        CLPopoverManager.showFlop { config in
            config.identifier = "AAA"
        }
    }

    func showDragView() {
        CLPopoverManager.showDrag { configure in
            configure.shouldAutorotate = true
            configure.supportedInterfaceOrientations = .all
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { configure in
                configure.shouldAutorotate = true
                configure.supportedInterfaceOrientations = .all
                configure.allowsEventPenetration = true
                configure.autoHideWhenPenetrated = true
                configure.popoverMode = .interrupt
                configure.userInterfaceStyleOverride = .unspecified
            }, title: "我是插队模式", message: "我会插队")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            CLPopoverManager.showOneAlert(configCallback: { configure in
                configure.shouldAutorotate = true
                configure.supportedInterfaceOrientations = .all
                configure.allowsEventPenetration = true
                configure.autoHideWhenPenetrated = true
                configure.popoverMode = .suspend
                configure.userInterfaceStyleOverride = .unspecified
            }, title: "我是挂起模式", message: "我会挂起前面弹窗，关闭后恢复")
        }
    }

    func showOneAlert() {
        CLPopoverManager.showFlop()
        CLPopoverManager.showOneAlert(configCallback: { configure in
            configure.shouldAutorotate = true
            configure.supportedInterfaceOrientations = .all
            configure.allowsEventPenetration = true
            configure.autoHideWhenPenetrated = true
            configure.popoverMode = .unique
            configure.userInterfaceStyleOverride = .unspecified
        }, title: "我是一个按钮", message: "我有一个按钮")
        CLPopoverManager.showDrag()
    }

    func showTwoAlert() {
        CLPopoverManager.showLoading()
        CLPopoverManager.showSuccess()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showTwoAlert(configCallback: { configure in
                configure.shouldAutorotate = true
                configure.popoverMode = .replaceInheritSuspend
                configure.supportedInterfaceOrientations = .all
            }, title: "我是两个按钮", message: "我有两个按钮")
            CLPopoverManager.showDrag()
        }
    }

    func showSuccess() {
        CLPopoverManager.showSuccess(configCallback: { configure in
            configure.shouldAutorotate = true
            configure.supportedInterfaceOrientations = .all
        }, text: "显示成功", dismissCallback: {
            print("success animation dismiss")
        })
    }

    func showError() {
        CLPopoverManager.showError(text: "显示错误", dismissCallback: {
            print("error animation dismiss")
        })
    }

    func showLoading() {
        CLPopoverManager.showLoading()
        CLPopoverManager.showSuccess()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showTwoAlert(configCallback: { configure in
                configure.shouldAutorotate = true
                configure.popoverMode = .replaceAll
                configure.supportedInterfaceOrientations = .all
            }, title: "我是两个按钮", message: "我有两个按钮")
            CLPopoverManager.showDrag()
        }
    }

    func showTips() {
        CLPopoverManager.showTips(text: "AAAAAAAAAAAAAAAAAAAA")
    }

    func showYearMonthDayDataPicker() {
        CLPopoverManager.showYearMonthDayDataPicker(yearMonthDayCallback: { year, month, day in
            print("选中-----\(year)年\(month)月\(day)日")
        })
    }

    func showHourMinuteDataPicker() {
        CLPopoverManager.showHourMinuteDataPicker(hourMinuteCallback: { hour, minute in
            print("选中-----\(hour)时\(minute)分")
        })
    }

    func showYearMonthDayHourMinuteDataPicker() {
        CLPopoverManager.showYearMonthDayHourMinuteDataPicker(yearMonthDayHourMinuteCallback: { year, month, day, hour, minute in
            print("选中-----\(year)年\(month)月\(day)日\(hour)时\(minute)分")
        })
    }

    func showBMIInput() {
        CLPopoverManager.showBMIInput(configCallback: { config in
        }, bmiCallback: { bmi in
            print("BMI-----\(bmi)")
        })
        CLPopoverManager.showOneInput(configCallback: { config in
            config.popoverMode = .suspend
        }, type: .pulse) { value in
            print("-----\(String(describing: value))")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            CLPopoverManager.showOneInput(configCallback: { config in
                config.popoverMode = .replaceInheritSuspend
            }, type: .heartRate) { value in
                print("-----\(String(describing: value))")
            }
        }
    }

    func showOneInput() {
        CLPopoverManager.showOneInput(type: .UrineVolume) { value in
            print("-----\(String(describing: value))")
        }
    }

    func showTwoInput() {
        CLPopoverManager.showTwoInput(type: .bloodPressure) { value1, value2 in
            print("-----\(String(describing: value1))----------\(String(describing: value2))")
        }
    }
}

// MARK: - 混合模式综合测试

extension CLPopupController {
    // MARK: - 测试1: queue模式基础测试

    func test1_QueueMode() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试1】queue模式基础测试")
        print("预期: A显示 -> B排队 -> C排队 -> A消失后B显示 -> B消失后C显示")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test1_A"
        }, title: "测试1-A", message: "queue模式")
        print("✓ 显示弹窗A (queue)")

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test1_B"
        }, title: "测试1-B", message: "queue模式")
        print("✓ 显示弹窗B (queue) - 应该排队")

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test1_C"
        }, title: "测试1-C", message: "queue模式")
        print("✓ 显示弹窗C (queue) - 应该排队")

        print("\n✋ 手动验证: 依次关闭弹窗,观察是否按A→B→C顺序显示")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试2: interrupt模式基础测试

    func test2_InterruptMode() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试2】interrupt模式基础测试")
        print("预期: A显示 -> B立即显示(重叠) -> C立即显示(重叠)")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .interrupt
            config.identifier = "test2_A"
        }, title: "测试2-A", message: "interrupt模式")
        print("✓ 显示弹窗A (interrupt)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .interrupt
                config.identifier = "test2_B"
            }, title: "测试2-B", message: "interrupt模式")
            print("✓ 显示弹窗B (interrupt) - 应该立即显示并重叠")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .interrupt
                config.identifier = "test2_C"
            }, title: "测试2-C", message: "interrupt模式")
            print("✓ 显示弹窗C (interrupt) - 应该立即显示并重叠")
        }

        print("\n✋ 手动验证: 应该看到3个弹窗重叠显示")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试3: suspend模式基础测试

    func test3_SuspendMode() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试3】suspend模式基础测试")
        print("预期: A显示 -> B显示且A被挂起 -> B消失后A恢复显示")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test3_A"
        }, title: "测试3-A", message: "我会被挂起")
        print("✓ 显示弹窗A (queue)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .suspend
                config.identifier = "test3_B"
            }, title: "测试3-B", message: "suspend模式,关闭后A会恢复")
            print("✓ 显示弹窗B (suspend) - A应该被隐藏")
        }

        print("\n✋ 手动验证: 先看到A,然后B出现A消失,关闭B后A应该恢复")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试4: replaceInheritSuspend模式测试

    func test4_ReplaceInheritSuspendMode() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试4】replaceInheritSuspend模式测试")
        print("预期: A显示 -> B替换A -> B消失后无弹窗")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test4_A"
        }, title: "测试4-A", message: "我会被替换")
        print("✓ 显示弹窗A (queue)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .replaceInheritSuspend
                config.identifier = "test4_B"
            }, title: "测试4-B", message: "replaceInheritSuspend模式")
            print("✓ 显示弹窗B (replaceInheritSuspend) - A应该被替换")
        }

        print("\n✋ 手动验证: A被B替换,关闭B后无弹窗")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试5: replaceClearSuspend模式测试

    func test5_ReplaceClearSuspendMode() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试5】replaceClearSuspend模式测试")
        print("预期: A显示 -> B替换A并清除挂起链 -> B消失后无弹窗")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test5_A"
        }, title: "测试5-A", message: "我会被替换")
        print("✓ 显示弹窗A (queue)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .replaceClearSuspend
                config.identifier = "test5_B"
            }, title: "测试5-B", message: "replaceClearSuspend模式")
            print("✓ 显示弹窗B (replaceClearSuspend) - A应该被替换")
        }

        print("\n✋ 手动验证: A被B替换,关闭B后无弹窗")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试6: replaceAll模式测试

    func test6_ReplaceAllMode() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试6】replaceAll模式测试")
        print("预期: A显示 -> B排队 -> C显示并清除A和B -> 只有C显示")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test6_A"
        }, title: "测试6-A", message: "我会被清除")
        print("✓ 显示弹窗A (queue)")

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test6_B"
        }, title: "测试6-B", message: "我会被清除")
        print("✓ 显示弹窗B (queue) - 应该排队")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .replaceAll
                config.identifier = "test6_C"
            }, title: "测试6-C", message: "replaceAll模式")
            print("✓ 显示弹窗C (replaceAll) - A和B都应该被清除")
        }

        print("\n✋ 手动验证: 只看到C,A和B都被清除")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试7: unique模式测试

    func test7_UniqueMode() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试7】unique模式测试")
        print("预期: A显示 -> B被阻止 -> C被阻止 -> 只有A显示")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .unique
            config.identifier = "test7_A"
        }, title: "测试7-A", message: "unique模式,阻止后续")
        print("✓ 显示弹窗A (unique)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.identifier = "test7_B"
            }, title: "测试7-B", message: "我会被阻止")
            print("✓ 尝试显示弹窗B (queue) - 应该被阻止")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .interrupt
                config.identifier = "test7_C"
            }, title: "测试7-C", message: "我会被阻止")
            print("✓ 尝试显示弹窗C (interrupt) - 应该被阻止")
        }

        print("\n✋ 手动验证: 只看到A,B和C都被阻止")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试8: 优先级测试

    func test8_PriorityQueue() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试8】优先级测试")
        print("预期: A显示 -> low/medium/high排队 -> A消失后按high->medium->low顺序显示")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.popoverPriority = .medium
            config.identifier = "test8_A"
        }, title: "测试8-A", message: "先显示的,关闭后看优先级")
        print("✓ 显示弹窗A (queue, medium)")

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.popoverPriority = .low
            config.identifier = "test8_Low"
        }, title: "测试8-Low", message: "low优先级,最后显示")
        print("✓ 显示弹窗Low (queue, low) - 排队")

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.popoverPriority = .high
            config.identifier = "test8_High"
        }, title: "测试8-High", message: "high优先级,第一个显示")
        print("✓ 显示弹窗High (queue, high) - 排队")

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.popoverPriority = .medium
            config.identifier = "test8_Medium"
        }, title: "测试8-Medium", message: "medium优先级,第二个显示")
        print("✓ 显示弹窗Medium (queue, medium) - 排队")

        print("\n✋ 手动验证: 关闭A后应按 High → Medium → Low 顺序显示")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试9: queue + interrupt 混合

    func test9_QueueWithInterrupt() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试9】queue + interrupt 混合测试")
        print("预期: A显示 -> B排队 -> C插队(与A重叠) -> A消失后B显示")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test9_A"
        }, title: "测试9-A", message: "queue模式")
        print("✓ 显示弹窗A (queue)")

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test9_B"
        }, title: "测试9-B", message: "queue模式,排队中")
        print("✓ 显示弹窗B (queue) - 排队")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .interrupt
                config.identifier = "test9_C"
            }, title: "测试9-C", message: "interrupt插队")
            print("✓ 显示弹窗C (interrupt) - 应该与A重叠")
        }

        print("\n✋ 手动验证: 看到A和C重叠,关闭A后B显示,C不影响队列")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试10: queue + suspend 混合

    func test10_QueueWithSuspend() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试10】queue + suspend 混合测试")
        print("预期: A显示 -> B排队 -> C挂起A -> C消失后A恢复 -> A消失后B显示")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test10_A"
        }, title: "测试10-A", message: "queue模式")
        print("✓ 显示弹窗A (queue)")

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test10_B"
        }, title: "测试10-B", message: "queue模式,排队中")
        print("✓ 显示弹窗B (queue) - 排队")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .suspend
                config.identifier = "test10_C"
            }, title: "测试10-C", message: "suspend挂起A")
            print("✓ 显示弹窗C (suspend) - A应该被挂起")
        }

        print("\n✋ 手动验证: A→C显示(A被挂起)→关闭C后A恢复→关闭A后B显示")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试11: interrupt + suspend 混合

    func test11_InterruptWithSuspend() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试11】interrupt + suspend 混合测试")
        print("预期: A和B重叠显示 -> C挂起A和B -> C消失后A和B恢复")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .interrupt
            config.identifier = "test11_A"
        }, title: "测试11-A", message: "interrupt模式")
        print("✓ 显示弹窗A (interrupt)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .interrupt
                config.identifier = "test11_B"
            }, title: "测试11-B", message: "interrupt模式")
            print("✓ 显示弹窗B (interrupt) - 与A重叠")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .suspend
                config.identifier = "test11_C"
            }, title: "测试11-C", message: "suspend挂起A和B")
            print("✓ 显示弹窗C (suspend) - A和B都应该被挂起")
        }

        print("\n✋ 手动验证: A和B重叠→C显示(A和B被挂起)→关闭C后A和B恢复")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试12: suspend嵌套测试

    func test12_NestedSuspend() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试12】suspend嵌套测试")
        print("预期: A显示 -> B挂起A -> C挂起B -> 关闭C后B恢复 -> 关闭B后A恢复")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test12_A"
        }, title: "测试12-A", message: "最底层")
        print("✓ 显示弹窗A (queue)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .suspend
                config.identifier = "test12_B"
            }, title: "测试12-B", message: "挂起A")
            print("✓ 显示弹窗B (suspend) - 挂起A")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .suspend
                config.identifier = "test12_C"
            }, title: "测试12-C", message: "挂起B")
            print("✓ 显示弹窗C (suspend) - 挂起B")
        }

        print("\n✋ 手动验证: A→B(A挂起)→C(B挂起)→关闭C后B恢复→关闭B后A恢复")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试13: replaceInheritSuspend继承挂起链

    func test13_InheritSuspendChain() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试13】replaceInheritSuspend继承挂起链测试")
        print("预期: A显示 -> B挂起A -> C替换B并继承挂起链 -> 关闭C后A恢复")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test13_A"
        }, title: "测试13-A", message: "最底层")
        print("✓ 显示弹窗A (queue)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .suspend
                config.identifier = "test13_B"
            }, title: "测试13-B", message: "挂起A")
            print("✓ 显示弹窗B (suspend) - 挂起A")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .replaceInheritSuspend
                config.identifier = "test13_C"
            }, title: "测试13-C", message: "替换B并继承挂起链")
            print("✓ 显示弹窗C (replaceInheritSuspend) - 替换B并继承对A的挂起")
        }

        print("\n✋ 手动验证: A→B(A挂起)→C替换B→关闭C后A恢复(证明继承了挂起链)")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试14: replaceClearSuspend清除挂起链

    func test14_ClearSuspendChain() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试14】replaceClearSuspend清除挂起链测试")
        print("预期: A显示 -> B挂起A -> C替换B并清除挂起链 -> 关闭C后无弹窗")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test14_A"
        }, title: "测试14-A", message: "会被清除")
        print("✓ 显示弹窗A (queue)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .suspend
                config.identifier = "test14_B"
            }, title: "测试14-B", message: "挂起A")
            print("✓ 显示弹窗B (suspend) - 挂起A")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .replaceClearSuspend
                config.identifier = "test14_C"
            }, title: "测试14-C", message: "替换B并清除挂起链")
            print("✓ 显示弹窗C (replaceClearSuspend) - 替换B并清除A")
        }

        print("\n✋ 手动验证: A→B(A挂起)→C替换B并清除A→关闭C后无弹窗")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试15: replaceAll清除所有

    func test15_ReplaceAllClearEverything() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试15】replaceAll清除所有测试")
        print("预期: A显示 -> B挂起A -> C排队 -> D替换所有 -> 只有D显示")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test15_A"
        }, title: "测试15-A", message: "会被清除")
        print("✓ 显示弹窗A (queue)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .suspend
                config.identifier = "test15_B"
            }, title: "测试15-B", message: "会被清除")
            print("✓ 显示弹窗B (suspend) - 挂起A")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.identifier = "test15_C"
            }, title: "测试15-C", message: "会被清除")
            print("✓ 显示弹窗C (queue) - 排队")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .replaceAll
                config.identifier = "test15_D"
            }, title: "测试15-D", message: "replaceAll清除所有")
            print("✓ 显示弹窗D (replaceAll) - 清除A/B/C")
        }

        print("\n✋ 手动验证: 只看到D,A/B/C都被清除")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试16: unique阻止后续弹窗

    func test16_UniqueBlockSubsequent() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试16】unique阻止后续弹窗测试")
        print("预期: A排队 -> B显示(unique) -> A被清除 -> C被阻止 -> 只有B显示")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test16_A"
        }, title: "测试16-A", message: "先显示")
        print("✓ 显示弹窗A (queue)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .unique
                config.identifier = "test16_B"
            }, title: "测试16-B", message: "unique模式")
            print("✓ 显示弹窗B (unique) - 清除A并阻止后续")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.identifier = "test16_C"
            }, title: "测试16-C", message: "会被阻止")
            print("✓ 尝试显示弹窗C (queue) - 应该被阻止")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .interrupt
                config.identifier = "test16_D"
            }, title: "测试16-D", message: "会被阻止")
            print("✓ 尝试显示弹窗D (interrupt) - 应该被阻止")
        }

        print("\n✋ 手动验证: A被B替换,C和D都被阻止,只有B显示")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试17: 复杂混合场景1

    func test17_ComplexMix1() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试17】复杂混合场景1 - queue队列中插入suspend")
        print("预期: A显示 -> B/C排队 -> D挂起A -> D消失后A恢复 -> A消失后按优先级显示B或C")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.popoverPriority = .medium
            config.identifier = "test17_A"
        }, title: "测试17-A", message: "queue-medium")
        print("✓ 显示弹窗A (queue, medium)")

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.popoverPriority = .low
            config.identifier = "test17_B"
        }, title: "测试17-B", message: "queue-low,排队")
        print("✓ 显示弹窗B (queue, low) - 排队")

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.popoverPriority = .high
            config.identifier = "test17_C"
        }, title: "测试17-C", message: "queue-high,排队")
        print("✓ 显示弹窗C (queue, high) - 排队")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .suspend
                config.identifier = "test17_D"
            }, title: "测试17-D", message: "suspend挂起A")
            print("✓ 显示弹窗D (suspend) - 挂起A,B/C仍在队列")
        }

        print("\n✋ 手动验证: A→D(A挂起)→关闭D后A恢复→关闭A后C显示(高优先级)→关闭C后B显示")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试18: 复杂混合场景2

    func test18_ComplexMix2() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试18】复杂混合场景2 - 多层suspend后replace")
        print("预期: A显示 -> B挂起A -> C挂起B -> D替换C并继承 -> 关闭D后B恢复 -> 关闭B后A恢复")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test18_A"
        }, title: "测试18-A", message: "最底层")
        print("✓ 显示弹窗A (queue)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .suspend
                config.identifier = "test18_B"
            }, title: "测试18-B", message: "挂起A")
            print("✓ 显示弹窗B (suspend) - 挂起A")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .suspend
                config.identifier = "test18_C"
            }, title: "测试18-C", message: "挂起B")
            print("✓ 显示弹窗C (suspend) - 挂起B")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .replaceInheritSuspend
                config.identifier = "test18_D"
            }, title: "测试18-D", message: "替换C并继承挂起链")
            print("✓ 显示弹窗D (replaceInheritSuspend) - 替换C并继承对B的挂起")
        }

        print("\n✋ 手动验证: A→B(A挂起)→C(B挂起)→D替换C→关闭D后B恢复→关闭B后A恢复")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试19: 复杂混合场景3

    func test19_ComplexMix3() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试19】复杂混合场景3 - 优先级+多模式混合")
        print("预期: 多个弹窗混合模式,测试优先级和模式交互")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.popoverPriority = .low
            config.identifier = "test19_A"
        }, title: "测试19-A", message: "queue-low")
        print("✓ 显示弹窗A (queue, low)")

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.popoverPriority = .high
            config.identifier = "test19_B"
        }, title: "测试19-B", message: "queue-high,排队")
        print("✓ 显示弹窗B (queue, high) - 排队")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .interrupt
                config.identifier = "test19_C"
            }, title: "测试19-C", message: "interrupt插队")
            print("✓ 显示弹窗C (interrupt) - 与A重叠")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .suspend
                config.identifier = "test19_D"
            }, title: "测试19-D", message: "suspend挂起所有")
            print("✓ 显示弹窗D (suspend) - 挂起A和C")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.popoverPriority = .medium
                config.identifier = "test19_E"
            }, title: "测试19-E", message: "queue-medium,排队")
            print("✓ 显示弹窗E (queue, medium) - 排队")
        }

        print("\n✋ 手动验证: A和C重叠→D挂起A和C→关闭D后A和C恢复→关闭A后按B(high)→E(medium)顺序")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试20: identifier去重测试

    func test20_IdentifierDeduplication() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试20】identifier去重测试")
        print("预期: 相同identifier的弹窗只显示一次")
        print(String(repeating: "=", count: 60))

        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "same_id"
        }, title: "测试20-A", message: "identifier=same_id")
        print("✓ 显示弹窗A (identifier=same_id)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.identifier = "same_id"
            }, title: "测试20-B", message: "identifier=same_id")
            print("✓ 尝试显示弹窗B (identifier=same_id) - 应该被去重")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .interrupt
                config.identifier = "same_id"
            }, title: "测试20-C", message: "identifier=same_id")
            print("✓ 尝试显示弹窗C (identifier=same_id, interrupt) - 应该被去重")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.identifier = "different_id"
            }, title: "测试20-D", message: "identifier=different_id")
            print("✓ 显示弹窗D (identifier=different_id) - 排队")
        }

        print("\n✋ 手动验证: 只看到A,B和C被去重,关闭A后D显示")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试21: 自定义导航控制器 + suspend模式

    func test21_NavigationControllerWithSuspend() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试21】自定义导航控制器 + suspend模式")
        print("预期: A显示 -> B(导航控制器)挂起A -> push到C -> 在C中关闭B -> A恢复")
        print(String(repeating: "=", count: 60))

        // 先显示弹窗A
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test21_A"
        }, title: "测试21-A", message: "我会被弹窗B挂起\n关闭B后我会恢复")
        print("✓ 显示弹窗A (queue)")

        // 0.5秒后显示弹窗B（自定义导航控制器，使用suspend模式）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let navController = CLPopupNavigationController()
            navController.config.popoverMode = .suspend
            navController.config.identifier = "test21_B"
            CLPopoverManager.show(navController)
            print("✓ 显示弹窗B (自定义导航控制器, suspend) - A应该被挂起")
            print("  -> 点击「Push到C控制器」进入C")
            print("  -> 在C中点击「关闭弹窗B」关闭整个弹窗B，A恢复")
        }

        print("\n✋ 手动验证流程:")
        print("  1. 看到弹窗A")
        print("  2. 弹窗B出现，A消失（被挂起）")
        print("  3. 点击「Push到C控制器」进入C")
        print("  4. 在C中点击「关闭弹窗B」")
        print("  5. 弹窗B关闭，弹窗A恢复显示")
        print(String(repeating: "=", count: 60) + "\n")
    }
}
