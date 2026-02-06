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

        // ==================== groupID 自动化测试 ====================
        do {
            let model = CLPopupModel()
            model.title = "🚀【自动化测试】运行所有 groupID 测试（自动验证结果）"
            model.callback = { [weak self] in
                self?.runAllGroupIDAutoTests()
            }
            arrayDS.append(model)
        }

        // ==================== groupID 分组测试 ====================
        do {
            let model = CLPopupModel()
            model.title = "【测试22】groupID分组隔离 - 预期:A组和B组各自独立排队"
            model.callback = { [weak self] in
                self?.test22_GroupIDIsolation()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试23】groupID+queue - 预期:不同分组不互相排队"
            model.callback = { [weak self] in
                self?.test23_GroupIDWithQueue()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试24】groupID+suspend - 预期:只挂起同分组弹窗"
            model.callback = { [weak self] in
                self?.test24_GroupIDWithSuspend()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试25】groupID+replaceAll - 预期:只替换同分组"
            model.callback = { [weak self] in
                self?.test25_GroupIDWithReplaceAll()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试26】groupID+groupUnique - 预期:只阻止同分组后续弹窗"
            model.callback = { [weak self] in
                self?.test26_GroupIDWithGroupUnique()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试27】globalUnique - 预期:阻止所有分组后续弹窗"
            model.callback = { [weak self] in
                self?.test27_GlobalUnique()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试28】identifier全局去重 - 预期:不同groupID相同identifier被去重"
            model.callback = { [weak self] in
                self?.test28_IdentifierGlobalDedup()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试29】dismiss(forGroup:) - 预期:只清除指定分组"
            model.callback = { [weak self] in
                self?.test29_DismissForGroup()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试30】groupID+优先级 - 预期:各分组独立按优先级调度"
            model.callback = { [weak self] in
                self?.test30_GroupIDWithPriority()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试31】groupID+replaceInheritSuspend - 预期:只继承同分组挂起链"
            model.callback = { [weak self] in
                self?.test31_GroupIDWithReplaceInheritSuspend()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "【测试32】groupID复杂场景 - 预期:多分组混合模式测试"
            model.callback = { [weak self] in
                self?.test32_GroupIDComplexScenario()
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
            configure.popoverMode = .groupUnique
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
            config.popoverMode = .groupUnique
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
                config.popoverMode = .groupUnique
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

    // MARK: - 测试22: groupID分组隔离

    func test22_GroupIDIsolation() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试22】groupID分组隔离测试")
        print("预期: A组弹窗1显示 -> B组弹窗1立即显示 -> 两组各自独立排队")
        print(String(repeating: "=", count: 60))

        // A组弹窗1
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.identifier = "test22_A1"
        }, title: "A组-弹窗1", message: "groupID=GroupA\n我是A组第一个")
        print("✓ 显示A组-弹窗1 (queue, groupID=GroupA)")

        // A组弹窗2排队
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.identifier = "test22_A2"
        }, title: "A组-弹窗2", message: "groupID=GroupA\n我在A组排队")
        print("✓ 显示A组-弹窗2 (queue, groupID=GroupA) - 在A组排队")

        // B组弹窗1 - 应该立即显示，因为B组没有正在显示的弹窗
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "test22_B1"
            }, title: "B组-弹窗1", message: "groupID=GroupB\n我是B组第一个,立即显示")
            print("✓ 显示B组-弹窗1 (queue, groupID=GroupB) - 应该立即显示")
        }

        // B组弹窗2排队
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "test22_B2"
            }, title: "B组-弹窗2", message: "groupID=GroupB\n我在B组排队")
            print("✓ 显示B组-弹窗2 (queue, groupID=GroupB) - 在B组排队")
        }

        print("\n✋ 手动验证:")
        print("  - A组弹窗1和B组弹窗1应该同时显示（重叠）")
        print("  - 关闭A组弹窗1后,A组弹窗2显示")
        print("  - 关闭B组弹窗1后,B组弹窗2显示")
        print("  - 两组互不影响")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试23: groupID + queue模式

    func test23_GroupIDWithQueue() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试23】groupID + queue模式测试")
        print("预期: 不同分组的queue弹窗不互相等待")
        print(String(repeating: "=", count: 60))

        // 默认分组弹窗
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "test23_default"
        }, title: "默认组-弹窗", message: "groupID=nil(默认)")
        print("✓ 显示默认组弹窗 (queue, groupID=nil)")

        // A组弹窗 - 应该立即显示
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupA"
                config.identifier = "test23_A"
            }, title: "A组-弹窗", message: "groupID=GroupA\n我立即显示,不排队")
            print("✓ 显示A组弹窗 (queue, groupID=GroupA) - 应该立即显示")
        }

        // B组弹窗 - 应该立即显示
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "test23_B"
            }, title: "B组-弹窗", message: "groupID=GroupB\n我立即显示,不排队")
            print("✓ 显示B组弹窗 (queue, groupID=GroupB) - 应该立即显示")
        }

        print("\n✋ 手动验证: 应该看到3个弹窗重叠显示（不同分组不互相排队）")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试24: groupID + suspend模式

    func test24_GroupIDWithSuspend() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试24】groupID + suspend模式测试")
        print("预期: suspend只挂起同分组弹窗")
        print(String(repeating: "=", count: 60))

        // A组弹窗1
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.identifier = "test24_A1"
        }, title: "A组-弹窗1", message: "groupID=GroupA\n会被A组suspend挂起")
        print("✓ 显示A组-弹窗1 (queue, groupID=GroupA)")

        // B组弹窗1 - 立即显示
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "test24_B1"
            }, title: "B组-弹窗1", message: "groupID=GroupB\n不会被A组suspend影响")
            print("✓ 显示B组-弹窗1 (queue, groupID=GroupB)")
        }

        // A组suspend弹窗 - 只挂起A组弹窗1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .suspend
                config.groupID = "GroupA"
                config.identifier = "test24_A_suspend"
            }, title: "A组-Suspend弹窗", message: "groupID=GroupA,suspend模式\n只挂起A组弹窗1,B组不受影响")
            print("✓ 显示A组-Suspend弹窗 - 只应该挂起A组弹窗1")
        }

        print("\n✋ 手动验证:")
        print("  - A组弹窗1和B组弹窗1重叠显示")
        print("  - A组Suspend弹窗出现后,只有A组弹窗1消失")
        print("  - B组弹窗1仍然显示")
        print("  - 关闭A组Suspend弹窗后,A组弹窗1恢复")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试25: groupID + replaceAll模式

    func test25_GroupIDWithReplaceAll() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试25】groupID + replaceAll模式测试")
        print("预期: replaceAll只替换同分组弹窗")
        print(String(repeating: "=", count: 60))

        // A组弹窗1
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.identifier = "test25_A1"
        }, title: "A组-弹窗1", message: "groupID=GroupA\n会被A组replaceAll清除")
        print("✓ 显示A组-弹窗1 (queue, groupID=GroupA)")

        // A组弹窗2排队
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.identifier = "test25_A2"
        }, title: "A组-弹窗2", message: "groupID=GroupA\n会被A组replaceAll清除")
        print("✓ 显示A组-弹窗2 (queue, groupID=GroupA) - 排队")

        // B组弹窗1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "test25_B1"
            }, title: "B组-弹窗1", message: "groupID=GroupB\n不会被A组replaceAll影响")
            print("✓ 显示B组-弹窗1 (queue, groupID=GroupB)")
        }

        // A组replaceAll弹窗
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .replaceAll
                config.groupID = "GroupA"
                config.identifier = "test25_A_replace"
            }, title: "A组-ReplaceAll弹窗", message: "groupID=GroupA,replaceAll模式\n清除A组所有,B组不受影响")
            print("✓ 显示A组-ReplaceAll弹窗 - 只应该清除A组弹窗1和弹窗2")
        }

        print("\n✋ 手动验证:")
        print("  - A组弹窗1和B组弹窗1重叠显示")
        print("  - A组ReplaceAll弹窗出现后,A组弹窗1消失,A组弹窗2从队列中移除")
        print("  - B组弹窗1仍然显示")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试26: groupID + groupUnique模式

    func test26_GroupIDWithGroupUnique() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试26】groupID + groupUnique模式测试")
        print("预期: groupUnique只阻止同分组后续弹窗")
        print(String(repeating: "=", count: 60))

        // A组groupUnique弹窗
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .groupUnique
            config.groupID = "GroupA"
            config.identifier = "test26_A_unique"
        }, title: "A组-GroupUnique弹窗", message: "groupID=GroupA,groupUnique模式\n只阻止A组后续弹窗")
        print("✓ 显示A组-GroupUnique弹窗")

        // A组后续弹窗 - 应该被阻止
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupA"
                config.identifier = "test26_A2"
            }, title: "A组-弹窗2", message: "我应该被阻止")
            print("✓ 尝试显示A组-弹窗2 - 应该被阻止")
        }

        // B组弹窗 - 应该立即显示
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "test26_B1"
            }, title: "B组-弹窗1", message: "groupID=GroupB\n我不受A组groupUnique影响")
            print("✓ 显示B组-弹窗1 - 应该立即显示")
        }

        // 默认组弹窗 - 应该立即显示
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.identifier = "test26_default"
            }, title: "默认组-弹窗", message: "groupID=nil\n我不受A组groupUnique影响")
            print("✓ 显示默认组弹窗 - 应该立即显示")
        }

        print("\n✋ 手动验证:")
        print("  - A组GroupUnique弹窗显示")
        print("  - A组弹窗2被阻止,不显示")
        print("  - B组弹窗1和默认组弹窗正常显示,与A组重叠")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试27: globalUnique模式

    func test27_GlobalUnique() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试27】globalUnique模式测试")
        print("预期: globalUnique阻止所有分组后续弹窗")
        print(String(repeating: "=", count: 60))

        // globalUnique弹窗
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .globalUnique
            config.groupID = "GroupA"
            config.identifier = "test27_global"
        }, title: "GlobalUnique弹窗", message: "globalUnique模式\n阻止所有分组后续弹窗")
        print("✓ 显示GlobalUnique弹窗 (groupID=GroupA)")

        // A组后续弹窗 - 应该被阻止
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupA"
                config.identifier = "test27_A"
            }, title: "A组-弹窗", message: "我应该被阻止")
            print("✓ 尝试显示A组弹窗 - 应该被阻止")
        }

        // B组弹窗 - 应该被阻止
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "test27_B"
            }, title: "B组-弹窗", message: "我应该被阻止")
            print("✓ 尝试显示B组弹窗 - 应该被阻止")
        }

        // 默认组弹窗 - 应该被阻止
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .interrupt
                config.identifier = "test27_default"
            }, title: "默认组-弹窗", message: "我应该被阻止")
            print("✓ 尝试显示默认组弹窗(interrupt) - 应该被阻止")
        }

        print("\n✋ 手动验证: 只看到GlobalUnique弹窗,所有后续弹窗都被阻止")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试28: identifier全局去重

    func test28_IdentifierGlobalDedup() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试28】identifier全局去重测试")
        print("预期: 相同identifier即使不同groupID也会被去重")
        print(String(repeating: "=", count: 60))

        // A组弹窗
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.identifier = "same_global_id"
        }, title: "A组-弹窗", message: "groupID=GroupA\nidentifier=same_global_id")
        print("✓ 显示A组弹窗 (identifier=same_global_id)")

        // B组弹窗 - 相同identifier,应该被去重
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "same_global_id"
            }, title: "B组-弹窗", message: "我应该被去重")
            print("✓ 尝试显示B组弹窗 (identifier=same_global_id) - 应该被去重")
        }

        // 默认组弹窗 - 相同identifier,应该被去重
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .interrupt
                config.identifier = "same_global_id"
            }, title: "默认组-弹窗", message: "我应该被去重")
            print("✓ 尝试显示默认组弹窗 (identifier=same_global_id, interrupt) - 应该被去重")
        }

        // 不同identifier - 应该显示
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "different_id"
            }, title: "B组-另一个弹窗", message: "groupID=GroupB\nidentifier=different_id\n我应该显示")
            print("✓ 显示B组另一个弹窗 (identifier=different_id) - 应该显示")
        }

        print("\n✋ 手动验证:")
        print("  - 只看到A组弹窗和B组另一个弹窗(重叠)")
        print("  - B组弹窗和默认组弹窗因为相同identifier被去重")
        print("  - 证明identifier是全局去重,不受groupID影响")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试29: dismiss(forGroup:)

    func test29_DismissForGroup() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试29】dismiss(forGroup:)测试")
        print("预期: 只清除指定分组的弹窗")
        print(String(repeating: "=", count: 60))

        // A组弹窗1
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.identifier = "test29_A1"
        }, title: "A组-弹窗1", message: "groupID=GroupA\n2秒后会被dismiss(forGroup:)清除")
        print("✓ 显示A组-弹窗1")

        // A组弹窗2排队
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.identifier = "test29_A2"
        }, title: "A组-弹窗2", message: "groupID=GroupA\n我在排队也会被清除")
        print("✓ 显示A组-弹窗2 - 排队")

        // B组弹窗
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "test29_B1"
            }, title: "B组-弹窗", message: "groupID=GroupB\n我不会被清除")
            print("✓ 显示B组弹窗")
        }

        // 默认组弹窗
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.identifier = "test29_default"
            }, title: "默认组-弹窗", message: "groupID=nil\n我不会被清除")
            print("✓ 显示默认组弹窗")
        }

        // 2秒后清除A组
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("\n🗑️ 执行 dismiss(forGroup: \"GroupA\")")
            CLPopoverManager.dismiss(forGroup: "GroupA")
        }

        print("\n✋ 手动验证:")
        print("  - 先看到A组弹窗1、B组弹窗、默认组弹窗重叠")
        print("  - 2秒后A组弹窗1消失")
        print("  - B组弹窗和默认组弹窗仍然显示")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试30: groupID + 优先级

    func test30_GroupIDWithPriority() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试30】groupID + 优先级测试")
        print("预期: 各分组独立按优先级调度")
        print(String(repeating: "=", count: 60))

        // A组弹窗(显示中)
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.popoverPriority = .medium
            config.identifier = "test30_A_first"
        }, title: "A组-第一个", message: "groupID=GroupA\n关闭我后看优先级顺序")
        print("✓ 显示A组第一个弹窗")

        // A组排队(low)
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.popoverPriority = .low
            config.identifier = "test30_A_low"
        }, title: "A组-Low优先级", message: "groupID=GroupA,low\n最后显示")
        print("✓ A组-Low优先级排队")

        // A组排队(high)
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.popoverPriority = .high
            config.identifier = "test30_A_high"
        }, title: "A组-High优先级", message: "groupID=GroupA,high\n第一个显示")
        print("✓ A组-High优先级排队")

        // B组弹窗(显示中)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.popoverPriority = .medium
                config.identifier = "test30_B_first"
            }, title: "B组-第一个", message: "groupID=GroupB\n关闭我后看优先级顺序")
            print("✓ 显示B组第一个弹窗")
        }

        // B组排队(high)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.popoverPriority = .high
                config.identifier = "test30_B_high"
            }, title: "B组-High优先级", message: "groupID=GroupB,high")
            print("✓ B组-High优先级排队")
        }

        print("\n✋ 手动验证:")
        print("  - A组和B组各自独立排队调度")
        print("  - 关闭A组第一个后,A组High显示,再是Low")
        print("  - 关闭B组第一个后,B组High显示")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试31: groupID + replaceInheritSuspend

    func test31_GroupIDWithReplaceInheritSuspend() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试31】groupID + replaceInheritSuspend测试")
        print("预期: 只继承同分组的挂起链")
        print(String(repeating: "=", count: 60))

        // A组弹窗1
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.identifier = "test31_A1"
        }, title: "A组-弹窗1", message: "groupID=GroupA\n最底层")
        print("✓ 显示A组-弹窗1")

        // A组suspend弹窗
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .suspend
                config.groupID = "GroupA"
                config.identifier = "test31_A_suspend"
            }, title: "A组-Suspend弹窗", message: "groupID=GroupA,suspend\n挂起A组弹窗1")
            print("✓ 显示A组-Suspend弹窗 - 挂起A组弹窗1")
        }

        // B组弹窗
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "test31_B1"
            }, title: "B组-弹窗", message: "groupID=GroupB\n独立显示")
            print("✓ 显示B组弹窗")
        }

        // A组replaceInheritSuspend弹窗
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .replaceInheritSuspend
                config.groupID = "GroupA"
                config.identifier = "test31_A_replace"
            }, title: "A组-Replace弹窗", message: "groupID=GroupA\nreplaceInheritSuspend\n继承对A组弹窗1的挂起")
            print("✓ 显示A组-Replace弹窗 - 替换Suspend弹窗并继承挂起链")
        }

        print("\n✋ 手动验证:")
        print("  - A组弹窗1 -> A组Suspend(挂起1) -> B组弹窗 -> A组Replace(替换Suspend)")
        print("  - 关闭A组Replace后,A组弹窗1恢复(证明继承了挂起链)")
        print("  - B组弹窗始终不受影响")
        print(String(repeating: "=", count: 60) + "\n")
    }

    // MARK: - 测试32: groupID复杂场景

    func test32_GroupIDComplexScenario() {
        print("\n" + String(repeating: "=", count: 60))
        print("【测试32】groupID复杂场景测试")
        print("预期: 多分组混合模式综合测试")
        print(String(repeating: "=", count: 60))

        // A组正常弹窗
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.popoverPriority = .low
            config.identifier = "test32_A1"
        }, title: "A组-弹窗1", message: "groupID=GroupA,low")
        print("✓ 显示A组-弹窗1")

        // A组排队
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.popoverPriority = .high
            config.identifier = "test32_A2"
        }, title: "A组-弹窗2", message: "groupID=GroupA,high\n排队")
        print("✓ A组-弹窗2排队")

        // B组正常弹窗
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "test32_B1"
            }, title: "B组-弹窗1", message: "groupID=GroupB")
            print("✓ 显示B组-弹窗1")
        }

        // A组suspend
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .suspend
                config.groupID = "GroupA"
                config.identifier = "test32_A_suspend"
            }, title: "A组-Suspend", message: "groupID=GroupA,suspend\n只挂起A组弹窗1")
            print("✓ 显示A组-Suspend - 挂起A组弹窗1,A组弹窗2仍在队列")
        }

        // 默认组弹窗
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.identifier = "test32_default"
            }, title: "默认组-弹窗", message: "groupID=nil\n独立显示")
            print("✓ 显示默认组弹窗")
        }

        // B组groupUnique
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .groupUnique
                config.groupID = "GroupB"
                config.identifier = "test32_B_unique"
            }, title: "B组-GroupUnique", message: "groupID=GroupB,groupUnique\n只影响B组")
            print("✓ 显示B组-GroupUnique - 只阻止B组后续弹窗")
        }

        // B组被阻止
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "test32_B_blocked"
            }, title: "B组-被阻止", message: "我应该被阻止")
            print("✓ 尝试显示B组弹窗 - 应该被阻止")
        }

        // A组正常显示
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupA"
                config.popoverPriority = .medium
                config.identifier = "test32_A3"
            }, title: "A组-弹窗3", message: "groupID=GroupA,medium\n不受B组groupUnique影响")
            print("✓ A组-弹窗3排队 - 不受B组groupUnique影响")
        }

        print("\n✋ 手动验证复杂交互:")
        print("  1. A组弹窗1、B组弹窗1同时显示")
        print("  2. A组Suspend出现,挂起A组弹窗1,B组不受影响")
        print("  3. 默认组弹窗出现,独立显示")
        print("  4. B组GroupUnique出现,清除B组弹窗1")
        print("  5. B组后续弹窗被阻止,A组弹窗3正常排队")
        print("  6. 关闭A组Suspend后,A组弹窗1恢复")
        print("  7. 关闭A组弹窗1后,A组弹窗2(high)显示,然后A组弹窗3(medium)")
        print(String(repeating: "=", count: 60) + "\n")
    }
}

// MARK: - 自动化测试框架

extension CLPopupController {
    /// 测试结果记录
    class TestResult {
        var testName: String
        var passed: Bool
        var message: String

        init(testName: String, passed: Bool, message: String) {
            self.testName = testName
            self.passed = passed
            self.message = message
        }
    }

    /// 测试上下文
    class TestContext {
        var results = [TestResult]()
        var currentTestName = ""
        var assertionCount = 0
        var passedCount = 0

        func startTest(_ name: String) {
            currentTestName = name
            print("\n" + String(repeating: "─", count: 60))
            print("🧪 开始测试: \(name)")
        }

        func assert(_ condition: Bool, _ message: String) {
            assertionCount += 1
            if condition {
                passedCount += 1
                print("  ✅ \(message)")
            } else {
                print("  ❌ \(message)")
            }
        }

        func assertEqual<T: Equatable>(_ actual: T, _ expected: T, _ message: String) {
            assertionCount += 1
            if actual == expected {
                passedCount += 1
                print("  ✅ \(message) [实际: \(actual)]")
            } else {
                print("  ❌ \(message) [期望: \(expected), 实际: \(actual)]")
            }
        }

        func finishTest() {
            let passed = passedCount == assertionCount
            results.append(TestResult(
                testName: currentTestName,
                passed: passed,
                message: passed ? "全部通过" : "有断言失败"
            ))
            print("📋 测试结果: \(passed ? "✅ 通过" : "❌ 失败") (\(passedCount)/\(assertionCount))")
            assertionCount = 0
            passedCount = 0
        }

        func printSummary() {
            print("\n" + String(repeating: "═", count: 60))
            print("📊 测试报告")
            print(String(repeating: "═", count: 60))

            var totalPassed = 0
            var totalFailed = 0

            for result in results {
                let status = result.passed ? "✅" : "❌"
                print("\(status) \(result.testName)")
                if result.passed {
                    totalPassed += 1
                } else {
                    totalFailed += 1
                }
            }

            print(String(repeating: "─", count: 60))
            print("总计: \(results.count) 个测试")
            print("通过: \(totalPassed) ✅")
            print("失败: \(totalFailed) ❌")
            print(String(repeating: "═", count: 60))

            if totalFailed == 0 {
                print("🎉 所有测试通过！groupID 功能正常！")
            } else {
                print("⚠️ 有 \(totalFailed) 个测试失败，请检查！")
            }
        }
    }

    /// 运行所有 groupID 自动化测试
    func runAllGroupIDAutoTests() {
        let ctx = TestContext()

        print("\n" + String(repeating: "═", count: 60))
        print("🚀 开始运行 groupID 自动化测试")
        print(String(repeating: "═", count: 60))

        // 清除所有弹窗
        CLPopoverManager.dismissAll()

        // 延时依次运行测试
        var delay: TimeInterval = 0.5

        // 测试1: 分组隔离
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.autoTest_GroupIDIsolation(ctx: ctx)
        }
        delay += 2.0

        // 测试2: queue 模式
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.autoTest_GroupIDWithQueue(ctx: ctx)
        }
        delay += 2.0

        // 测试3: suspend 模式
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.autoTest_GroupIDWithSuspend(ctx: ctx)
        }
        delay += 2.5

        // 测试4: replaceAll 模式
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.autoTest_GroupIDWithReplaceAll(ctx: ctx)
        }
        delay += 2.0

        // 测试5: groupUnique 模式
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.autoTest_GroupIDWithGroupUnique(ctx: ctx)
        }
        delay += 2.0

        // 测试6: globalUnique 模式
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.autoTest_GlobalUnique(ctx: ctx)
        }
        delay += 2.0

        // 测试7: identifier 全局去重
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.autoTest_IdentifierGlobalDedup(ctx: ctx)
        }
        delay += 2.0

        // 测试8: dismiss(forGroup:)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.autoTest_DismissForGroup(ctx: ctx)
        }
        delay += 2.5

        // 打印总结
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            CLPopoverManager.dismissAll()
            ctx.printSummary()
        }
    }

    // MARK: - 自动化测试用例

    func autoTest_GroupIDIsolation(ctx: TestContext) {
        CLPopoverManager.dismissAll()
        ctx.startTest("groupID 分组隔离")

        // 显示 A 组弹窗
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.identifier = "auto_A1"
        }, title: "A组", message: "测试")

        // 显示 A 组第二个弹窗（应该排队）
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.identifier = "auto_A2"
        }, title: "A组-2", message: "测试")

        // 显示 B 组弹窗（应该立即显示，因为 B 组没有弹窗）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "auto_B1"
            }, title: "B组", message: "测试")
        }

        // 验证
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            ctx.assertEqual(CLPopoverManager.activeCount(for: "GroupA"), 1, "A组活跃弹窗数量应为1")
            ctx.assertEqual(CLPopoverManager.activeCount(for: "GroupB"), 1, "B组活跃弹窗数量应为1")
            ctx.assertEqual(CLPopoverManager.waitQueueCount(for: "GroupA"), 1, "A组等待队列应为1")
            ctx.assertEqual(CLPopoverManager.waitQueueCount(for: "GroupB"), 0, "B组等待队列应为0")
            ctx.assert(CLPopoverManager.isActive(identifier: "auto_A1"), "auto_A1 应该正在显示")
            ctx.assert(CLPopoverManager.isActive(identifier: "auto_B1"), "auto_B1 应该正在显示")
            ctx.assert(CLPopoverManager.isInWaitQueue(identifier: "auto_A2"), "auto_A2 应该在等待队列")
            ctx.finishTest()
            CLPopoverManager.dismissAll()
        }
    }

    func autoTest_GroupIDWithQueue(ctx: TestContext) {
        CLPopoverManager.dismissAll()
        ctx.startTest("groupID + queue 模式")

        // 默认组弹窗
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.identifier = "auto_default"
        }, title: "默认组", message: "测试")

        // A 组弹窗
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupA"
                config.identifier = "auto_qA"
            }, title: "A组", message: "测试")
        }

        // B 组弹窗
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "auto_qB"
            }, title: "B组", message: "测试")
        }

        // 验证：三个不同分组的 queue 弹窗应该同时显示
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            ctx.assertEqual(CLPopoverManager.activeCount, 3, "总活跃弹窗数量应为3")
            ctx.assertEqual(CLPopoverManager.activeCount(for: nil), 1, "默认组活跃弹窗应为1")
            ctx.assertEqual(CLPopoverManager.activeCount(for: "GroupA"), 1, "A组活跃弹窗应为1")
            ctx.assertEqual(CLPopoverManager.activeCount(for: "GroupB"), 1, "B组活跃弹窗应为1")
            ctx.finishTest()
            CLPopoverManager.dismissAll()
        }
    }

    func autoTest_GroupIDWithSuspend(ctx: TestContext) {
        CLPopoverManager.dismissAll()
        ctx.startTest("groupID + suspend 模式")

        // A 组弹窗
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.identifier = "auto_sA1"
        }, title: "A组", message: "测试")

        // B 组弹窗
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "auto_sB1"
            }, title: "B组", message: "测试")
        }

        // A 组 suspend 弹窗（只应该挂起 A 组）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .suspend
                config.groupID = "GroupA"
                config.identifier = "auto_sA_suspend"
            }, title: "A组-Suspend", message: "测试")
        }

        // 验证
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ctx.assertEqual(CLPopoverManager.activeCount(for: "GroupA"), 1, "A组活跃弹窗应为1（suspend弹窗）")
            ctx.assertEqual(CLPopoverManager.activeCount(for: "GroupB"), 1, "B组活跃弹窗应为1（不受影响）")
            ctx.assert(CLPopoverManager.isActive(identifier: "auto_sA_suspend"), "auto_sA_suspend 应该正在显示")
            ctx.assert(CLPopoverManager.isActive(identifier: "auto_sB1"), "auto_sB1 应该正在显示（不受影响）")
            ctx.assert(CLPopoverManager.isSuspended(identifier: "auto_sA1"), "auto_sA1 应该被挂起")
            ctx.finishTest()
            CLPopoverManager.dismissAll()
        }
    }

    func autoTest_GroupIDWithReplaceAll(ctx: TestContext) {
        CLPopoverManager.dismissAll()
        ctx.startTest("groupID + replaceAll 模式")

        // A 组弹窗
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.identifier = "auto_rA1"
        }, title: "A组", message: "测试")

        // A 组排队
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.identifier = "auto_rA2"
        }, title: "A组-2", message: "测试")

        // B 组弹窗
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "auto_rB1"
            }, title: "B组", message: "测试")
        }

        // A 组 replaceAll（只清除 A 组）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .replaceAll
                config.groupID = "GroupA"
                config.identifier = "auto_rA_replace"
            }, title: "A组-ReplaceAll", message: "测试")
        }

        // 验证
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ctx.assertEqual(CLPopoverManager.activeCount(for: "GroupA"), 1, "A组活跃弹窗应为1（replaceAll弹窗）")
            ctx.assertEqual(CLPopoverManager.activeCount(for: "GroupB"), 1, "B组活跃弹窗应为1（不受影响）")
            ctx.assertEqual(CLPopoverManager.waitQueueCount(for: "GroupA"), 0, "A组等待队列应为0（被清除）")
            ctx.assert(CLPopoverManager.isActive(identifier: "auto_rA_replace"), "auto_rA_replace 应该正在显示")
            ctx.assert(CLPopoverManager.isActive(identifier: "auto_rB1"), "auto_rB1 应该正在显示（不受影响）")
            ctx.assert(!CLPopoverManager.isActive(identifier: "auto_rA1"), "auto_rA1 应该被清除")
            ctx.assert(!CLPopoverManager.isInWaitQueue(identifier: "auto_rA2"), "auto_rA2 应该从队列中被清除")
            ctx.finishTest()
            CLPopoverManager.dismissAll()
        }
    }

    func autoTest_GroupIDWithGroupUnique(ctx: TestContext) {
        CLPopoverManager.dismissAll()
        ctx.startTest("groupID + groupUnique 模式")

        // A 组 groupUnique 弹窗
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .groupUnique
            config.groupID = "GroupA"
            config.identifier = "auto_uA_unique"
        }, title: "A组-Unique", message: "测试")

        // A 组后续弹窗（应该被阻止）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupA"
                config.identifier = "auto_uA2"
            }, title: "A组-2", message: "测试")
        }

        // B 组弹窗（不应该被阻止）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "auto_uB1"
            }, title: "B组", message: "测试")
        }

        // 验证
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            ctx.assertEqual(CLPopoverManager.activeCount(for: "GroupA"), 1, "A组活跃弹窗应为1（unique阻止后续）")
            ctx.assertEqual(CLPopoverManager.activeCount(for: "GroupB"), 1, "B组活跃弹窗应为1（不受影响）")
            ctx.assert(CLPopoverManager.isActive(identifier: "auto_uA_unique"), "auto_uA_unique 应该正在显示")
            ctx.assert(!CLPopoverManager.isActive(identifier: "auto_uA2"), "auto_uA2 应该被阻止")
            ctx.assert(CLPopoverManager.isActive(identifier: "auto_uB1"), "auto_uB1 应该正在显示（不受阻止）")
            ctx.finishTest()
            CLPopoverManager.dismissAll()
        }
    }

    func autoTest_GlobalUnique(ctx: TestContext) {
        CLPopoverManager.dismissAll()
        ctx.startTest("globalUnique 模式")

        // globalUnique 弹窗
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .globalUnique
            config.groupID = "GroupA"
            config.identifier = "auto_global"
        }, title: "GlobalUnique", message: "测试")

        // A 组后续（应该被阻止）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupA"
                config.identifier = "auto_gA"
            }, title: "A组", message: "测试")
        }

        // B 组后续（应该被阻止）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "auto_gB"
            }, title: "B组", message: "测试")
        }

        // 默认组后续（应该被阻止）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .interrupt
                config.identifier = "auto_gDefault"
            }, title: "默认组", message: "测试")
        }

        // 验证
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            ctx.assertEqual(CLPopoverManager.activeCount, 1, "总活跃弹窗应为1（globalUnique阻止所有）")
            ctx.assert(CLPopoverManager.isActive(identifier: "auto_global"), "auto_global 应该正在显示")
            ctx.assert(!CLPopoverManager.isActive(identifier: "auto_gA"), "auto_gA 应该被阻止")
            ctx.assert(!CLPopoverManager.isActive(identifier: "auto_gB"), "auto_gB 应该被阻止")
            ctx.assert(!CLPopoverManager.isActive(identifier: "auto_gDefault"), "auto_gDefault 应该被阻止")
            ctx.finishTest()
            CLPopoverManager.dismissAll()
        }
    }

    func autoTest_IdentifierGlobalDedup(ctx: TestContext) {
        CLPopoverManager.dismissAll()
        ctx.startTest("identifier 全局去重")

        // A 组弹窗
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.identifier = "same_id"
        }, title: "A组", message: "测试")

        // B 组弹窗（相同 identifier，应该被去重）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "same_id"
            }, title: "B组", message: "测试")
        }

        // 不同 identifier（应该显示）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "different_id"
            }, title: "B组-不同ID", message: "测试")
        }

        // 验证
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            ctx.assertEqual(CLPopoverManager.activeCount, 2, "总活跃弹窗应为2（相同identifier被去重）")
            ctx.assertEqual(CLPopoverManager.activeCount(for: "GroupA"), 1, "A组活跃弹窗应为1")
            ctx.assertEqual(CLPopoverManager.activeCount(for: "GroupB"), 1, "B组活跃弹窗应为1（same_id被去重）")
            ctx.assert(CLPopoverManager.isActive(identifier: "same_id"), "same_id 应该正在显示（A组的）")
            ctx.assert(CLPopoverManager.isActive(identifier: "different_id"), "different_id 应该正在显示")
            ctx.finishTest()
            CLPopoverManager.dismissAll()
        }
    }

    func autoTest_DismissForGroup(ctx: TestContext) {
        CLPopoverManager.dismissAll()
        ctx.startTest("dismiss(forGroup:)")

        // A 组弹窗
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.identifier = "auto_dA1"
        }, title: "A组", message: "测试")

        // A 组排队
        CLPopoverManager.showOneAlert(configCallback: { config in
            config.popoverMode = .queue
            config.groupID = "GroupA"
            config.identifier = "auto_dA2"
        }, title: "A组-2", message: "测试")

        // B 组弹窗
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            CLPopoverManager.showOneAlert(configCallback: { config in
                config.popoverMode = .queue
                config.groupID = "GroupB"
                config.identifier = "auto_dB1"
            }, title: "B组", message: "测试")
        }

        // 清除 A 组
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.dismiss(forGroup: "GroupA")
        }

        // 验证
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ctx.assertEqual(CLPopoverManager.activeCount(for: "GroupA"), 0, "A组活跃弹窗应为0（被清除）")
            ctx.assertEqual(CLPopoverManager.waitQueueCount(for: "GroupA"), 0, "A组等待队列应为0（被清除）")
            ctx.assertEqual(CLPopoverManager.activeCount(for: "GroupB"), 1, "B组活跃弹窗应为1（不受影响）")
            ctx.assert(!CLPopoverManager.isActive(identifier: "auto_dA1"), "auto_dA1 应该被清除")
            ctx.assert(!CLPopoverManager.isInWaitQueue(identifier: "auto_dA2"), "auto_dA2 应该被清除")
            ctx.assert(CLPopoverManager.isActive(identifier: "auto_dB1"), "auto_dB1 应该正在显示（不受影响）")
            ctx.finishTest()
            CLPopoverManager.dismissAll()
        }
    }
}
