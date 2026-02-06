//
//  CLPopupCViewController.swift
//  CLPopoverManagerDemo
//
//  Created by JmoVxia on 2026/1/22.
//

import UIKit

// MARK: - C控制器 - 从弹窗B push进来的页面

class CLPopupCViewController: UIViewController {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "C控制器"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1)
        return label
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "我是从弹窗B push进来的\n点击下方按钮可以关闭整个弹窗B\n关闭后弹窗A会恢复显示"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.4, alpha: 1)
        label.numberOfLines = 0
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("关闭弹窗B", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1)
        button.layer.cornerRadius = 22
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("返回弹窗B", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)

        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(backButton)

        containerView.snp.makeConstraints { make in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.center.equalToSuperview()
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

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(24)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(44)
        }

        backButton.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-24)
        }
    }

    @objc private func closeAction() {
        guard let navController = navigationController as? CLPopupNavigationController else { return }
        CLPopoverManager.dismiss(forKey: navController.key)
    }

    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
}
