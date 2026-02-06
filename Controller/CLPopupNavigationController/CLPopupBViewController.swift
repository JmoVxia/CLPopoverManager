//
//  CLPopupBViewController.swift
//  CLPopoverManagerDemo
//
//  Created by JmoVxia on 2026/1/22.
//

import UIKit

// MARK: - 弹窗B的内容视图控制器

class CLPopupBViewController: UIViewController {
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        return contentView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "弹窗B"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .theme
        return label
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "我是suspend模式\n我会挂起弹窗A\n点击下方按钮可以push到C控制器"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.4, alpha: 1)
        label.numberOfLines = 0
        return label
    }()

    private lazy var pushButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Push到C控制器", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .theme
        button.layer.cornerRadius = 22
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(pushToCAction), for: .touchUpInside)
        return button
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("关闭弹窗B", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(pushButton)
        contentView.addSubview(closeButton)

        contentView.snp.makeConstraints { make in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.bottom.equalTo(view.snp.top)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(24)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }

        pushButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(24)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(44)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(pushButton.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-24)
        }
    }

    @objc private func pushToCAction() {
        let cVC = CLPopupCViewController()
        navigationController?.pushViewController(cVC, animated: true)
    }

    @objc private func closeAction() {
        guard let navController = navigationController as? CLPopupNavigationController else { return }
        CLPopoverManager.dismiss(forKey: navController.key)
    }

    func showAnimation(completion: (() -> Void)?) {
        view.setNeedsLayout()
        view.layoutIfNeeded()

        contentView.snp.remakeConstraints { make in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.center.equalToSuperview()
        }

        UIView.animate(withDuration: 0.35) {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion?()
        }
    }

    func dismissAnimation(completion: (() -> Void)?) {
        contentView.snp.remakeConstraints { make in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.bottom.equalTo(view.snp.top)
        }

        UIView.animate(withDuration: 0.35, animations: {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }) { _ in
            completion?()
        }
    }
}
