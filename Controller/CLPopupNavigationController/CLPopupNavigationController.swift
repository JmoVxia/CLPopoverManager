//
//  CLPopupNavigationController.swift
//  CLPopoverManagerDemo
//
//  Created by JmoVxia on 2026/1/22.
//

import UIKit

// MARK: - 弹窗B - 自定义导航控制器，遵守CLPopoverProtocol协议

class CLPopupNavigationController: UINavigationController {
    private var dismissCallback: (() -> Void)?

    init(dismissCallback: (() -> Void)? = nil) {
        self.dismissCallback = dismissCallback
        let rootVC = CLPopupBViewController()
        super.init(rootViewController: rootVC)
        rootVC.navigationController?.delegate = self
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .clear
    }

    deinit {
        print("CLPopupNavigationController deinit")
    }
}

// MARK: - UINavigationControllerDelegate

extension CLPopupNavigationController: UINavigationControllerDelegate {}

// MARK: - CLPopoverProtocol

extension CLPopupNavigationController: CLPopoverProtocol {
    func showAnimation(completion: (() -> Void)?) {
        guard let rootVC = viewControllers.first as? CLPopupBViewController else {
            completion?()
            return
        }
        rootVC.showAnimation(completion: completion)
    }

    func dismissAnimation(completion: (() -> Void)?) {
        guard let rootVC = viewControllers.first as? CLPopupBViewController else {
            completion?()
            return
        }
        rootVC.dismissAnimation { [weak self] in
            self?.dismissCallback?()
            completion?()
        }
    }
}
