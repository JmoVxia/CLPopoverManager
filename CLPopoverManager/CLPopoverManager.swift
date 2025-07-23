//
//  CLPopoverManager
//
//
//  Created by Chen JmoVxia on 2019/12/24.
//

import UIKit

// MARK: - 弹窗管理者

@objcMembers public class CLPopoverManager: NSObject {
    override private init() {
        super.init()
    }

    deinit {}

    private var waitQueue = [String: (controller: CLPopoverProtocol, enqueueTime: Date)]()

    private var windows = [String: CLPopoverWindow]()

    private var dismissingKeys = Set<String>()
}

public extension CLPopoverManager {
    @discardableResult static func mainSync<T>(execute block: () -> T) -> T {
        guard !Thread.isMainThread else { return block() }
        return DispatchQueue.main.sync { block() }
    }
}

public extension CLPopoverManager {
    private static var manager: CLPopoverManager?

    private static let singletonSemaphore: DispatchSemaphore = {
        let semap = DispatchSemaphore(value: 0)
        semap.signal()
        return semap
    }()

    private static var shared: CLPopoverManager {
        singletonSemaphore.wait()
        defer { singletonSemaphore.signal() }
        if let sharedManager = manager {
            return sharedManager
        } else {
            manager = CLPopoverManager()
            return manager!
        }
    }
}

public extension CLPopoverManager {
    /// 显示自定义弹窗
    static func show(_ controller: CLPopoverProtocol, completion: (() -> Void)? = nil) {
        mainSync {
            let shouldShow = !shared.windows.values.contains { $0.rootPopoverController?.config.popoverMode == .unique } &&
                !shared.windows.values.contains { $0.rootPopoverController?.config.identifier == controller.config.identifier && controller.config.identifier != nil } &&
                !shared.waitQueue.values.contains { $0.controller.key != controller.key && $0.controller.config.identifier == controller.config.identifier && controller.config.identifier != nil }

            guard shouldShow else { return }

            switch controller.config.popoverMode {
            case .queue, .interrupt:
                break
            case .replace:
                shared.windows.values.forEach { $0.isHidden = true }
                shared.windows.removeAll()
            case .unique:
                shared.waitQueue.removeAll()
                shared.windows.values.forEach { $0.isHidden = true }
                shared.windows.removeAll()
            }
            guard !(controller.config.popoverMode == .queue && !shared.windows.isEmpty) else {
                shared.waitQueue[controller.key] = (controller: controller, enqueueTime: Date())
                return
            }
            let window = CLPopoverWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = .clear
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = .init(rawValue: controller.config.userInterfaceStyleOverride.rawValue) ?? .light
            }
            window.autoHideWhenPenetrated = controller.config.autoHideWhenPenetrated
            window.allowsEventPenetration = controller.config.allowsEventPenetration
            window.windowLevel = .alert + 50
            window.rootViewController = controller
            window.makeKeyAndVisible()
            shared.windows[controller.key] = window
            shared.waitQueue.removeValue(forKey: controller.key)
            controller.showAnimation(completion: completion)
        }
    }

    /// 隐藏指定弹窗
    static func dismiss(_ key: String?, completion: (() -> Void)? = nil) {
        guard let key else { return }
        mainSync {
            guard !shared.dismissingKeys.contains(key) else { return }
            guard let window = shared.windows[key] else {
                shared.waitQueue.removeValue(forKey: key)
                completion?()
                return
            }
            shared.dismissingKeys.insert(key)
            window.rootPopoverController?.dismissAnimation {
                window.isHidden = true
                completion?()
                shared.windows.removeValue(forKey: key)
                shared.dismissingKeys.remove(key)
                guard !(shared.windows.isEmpty && shared.waitQueue.isEmpty) else { return dismissAll() }
                guard let nextController = shared.waitQueue.values.sorted(by: {
                    $0.controller.config.popoverPriority != $1.controller.config.popoverPriority ?
                        $0.controller.config.popoverPriority > $1.controller.config.popoverPriority :
                        $0.enqueueTime < $1.enqueueTime
                }).first?.controller else { return }
                show(nextController)
            }
        }
    }

    /// 隐藏所有弹窗
    static func dismissAll() {
        mainSync {
            shared.dismissingKeys.removeAll()
            shared.waitQueue.removeAll()
            shared.windows.values.forEach { $0.isHidden = true }
            shared.windows.removeAll()
            manager = nil
        }
    }
}
