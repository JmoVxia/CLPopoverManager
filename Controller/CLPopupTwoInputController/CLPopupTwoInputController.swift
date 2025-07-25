//
//  CLPopupTwoInputController.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/9.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

enum CLPopupTwoInputType {
    /// 体温
    case temperature
    /// 血压
    case bloodPressure
    /// 血糖
    case bloodSugar
}

class CLPopupTwoInputController: CLPopoverController {
    var sureCallback: ((String?, String?) -> Void)?
    var type: CLPopupTwoInputType = .temperature {
        didSet {
            switch type {
            case .temperature:
                titleLabel.text = "体温"
                fristTextField.keyboardType = .default
                fristTextField.setPlaceholder("请输入测量部位", color: .init("#999999"), font: UIFont.systemFont(ofSize: 16))
                secondTextField.keyboardType = .decimalPad
                secondTextField.setPlaceholder("请输入录入体温", color: .init("#999999"), font: UIFont.systemFont(ofSize: 16))
            case .bloodPressure:
                titleLabel.text = "血压"
                fristTextField.keyboardType = .decimalPad
                fristTextField.setPlaceholder("请输入收缩压(高压)", color: .init("#999999"), font: UIFont.systemFont(ofSize: 16))
                secondTextField.keyboardType = .decimalPad
                secondTextField.setPlaceholder("请输入舒张压(低压)", color: .init("#999999"), font: UIFont.systemFont(ofSize: 16))
            case .bloodSugar:
                titleLabel.text = "血糖"
                fristTextField.isUserInteractionEnabled = false
                fristTextField.setPlaceholder("请选择测量时间", color: .init("#999999"), font: UIFont.systemFont(ofSize: 16))
                secondTextField.keyboardType = .decimalPad
                secondTextField.setPlaceholder("请输入血糖值", color: .init("#999999"), font: UIFont.systemFont(ofSize: 16))
            }
        }
    }

    private var isMoveUp: Bool = false
    private var isDismiss: Bool = false
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        return contentView
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .theme
        titleLabel.numberOfLines = 0
        return titleLabel
    }()

    private lazy var fristTextField: UITextField = {
        let fristTextField = UITextField()
        fristTextField.delegate = self
        fristTextField.textAlignment = .center
        return fristTextField
    }()

    private lazy var fristLineView: UIView = {
        let fristLineView = UIView()
        fristLineView.backgroundColor = .init("#F0F0F0")
        return fristLineView
    }()

    private lazy var fristTapView: UIControl = {
        let fristTapView = UIControl()
        fristTapView.addTarget(self, action: #selector(fristTapViewAction), for: .touchUpInside)
        return fristTapView
    }()

    private lazy var secondTextField: UITextField = {
        let secondTextField = UITextField()
        secondTextField.delegate = self
        secondTextField.textAlignment = .center
        return secondTextField
    }()

    private lazy var secondLineView: UIView = {
        let secondLineView = UIView()
        secondLineView.backgroundColor = .init("#F0F0F0")
        return secondLineView
    }()

    private lazy var secondTapView: UIControl = {
        let secondTapView = UIControl()
        secondTapView.addTarget(self, action: #selector(secondTapViewAction), for: .touchUpInside)
        return secondTapView
    }()

    private lazy var sureButton: UIButton = {
        let sureButton = UIButton()
        sureButton.setTitle("确定", for: .normal)
        sureButton.setTitle("确定", for: .selected)
        sureButton.setTitle("确定", for: .highlighted)
        sureButton.setTitleColor(.white, for: .normal)
        sureButton.setTitleColor(.white, for: .selected)
        sureButton.setTitleColor(.white, for: .highlighted)
        sureButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sureButton.backgroundColor = .theme
        sureButton.layer.cornerRadius = 20
        sureButton.clipsToBounds = true
        sureButton.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        return sureButton
    }()

    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "clear"), for: .normal)
        closeButton.setImage(UIImage(named: "clear"), for: .selected)
        closeButton.setImage(UIImage(named: "clear"), for: .highlighted)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return closeButton
    }()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CLPopupTwoInputController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension CLPopupTwoInputController {
    private func initUI() {
        view.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.00)
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(fristTextField)
        contentView.addSubview(fristLineView)
        contentView.addSubview(fristTapView)
        contentView.addSubview(secondTextField)
        contentView.addSubview(secondLineView)
        contentView.addSubview(secondTapView)
        contentView.addSubview(sureButton)
        view.addSubview(closeButton)
    }

    private func makeConstraints() {
        contentView.snp.makeConstraints { make in
            make.left.equalTo(36)
            make.right.equalTo(-36)
            make.bottom.equalTo(view.snp.top)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(36)
            make.left.equalTo(21)
            make.right.equalTo(-21)
        }
        fristTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(36)
            make.left.equalTo(21)
            make.right.equalTo(-21)
        }
        fristLineView.snp.makeConstraints { make in
            make.top.equalTo(fristTextField.snp.bottom).offset(16)
            make.left.equalTo(21)
            make.right.equalTo(-21)
            make.height.equalTo(0.5)
        }
        fristTapView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(fristLineView)
        }
        secondTextField.snp.makeConstraints { make in
            make.top.equalTo(fristLineView.snp.bottom).offset(36)
            make.left.equalTo(21)
            make.right.equalTo(-21)
        }
        secondLineView.snp.makeConstraints { make in
            make.top.equalTo(secondTextField.snp.bottom).offset(16)
            make.left.equalTo(21)
            make.right.equalTo(-21)
            make.height.equalTo(0.5)
        }
        secondTapView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(fristLineView.snp.bottom)
            make.bottom.equalTo(secondLineView)
        }
        sureButton.snp.makeConstraints { make in
            make.left.equalTo(70)
            make.right.equalTo(-70)
            make.height.equalTo(40)
            make.bottom.equalTo(-32)
            make.top.equalTo(secondLineView.snp.bottom).offset(20)
        }
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.top).offset(-15)
        }
    }
}

extension CLPopupTwoInputController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
}

extension CLPopupTwoInputController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text else {
            return true
        }
        let text = (textFieldText as NSString).replacingCharacters(in: range, with: string)
        if string == "" {
            return true
        }
        switch type {
        case .bloodPressure:
            return text.isValidDecimalPointCount(1)
        case .temperature:
            if textField == fristTextField {
                return true
            } else {
                return text.isValidDecimalPointCount(1)
            }
        case .bloodSugar:
            if textField == fristTextField {
                return true
            } else {
                return text.isValidDecimalPointCount(2)
            }
        }
    }
}

extension CLPopupTwoInputController {
    // 键盘显示
    @objc func keyboardWillShow(notification: Notification) {
        DispatchQueue.main.async {
            guard let userInfo = notification.userInfo, let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval, let options = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSInteger else { return }
            let margin = keyboardRect.minY - 10
            self.isMoveUp = self.contentView.frame.maxY - keyboardRect.minY > 0
            if self.isMoveUp {
                self.contentView.snp.remakeConstraints { make in
                    make.left.equalTo(36)
                    make.right.equalTo(-36)
                    make.bottom.equalTo(self.view.snp.top).offset(margin)
                }
                UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(options)), animations: {
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                })
            }
        }
    }

    // 键盘隐藏
    @objc func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo, let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval, let options = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSInteger else { return }
        if !isDismiss, isMoveUp {
            DispatchQueue.main.async {
                self.contentView.snp.remakeConstraints { make in
                    make.left.equalTo(36)
                    make.right.equalTo(-36)
                    make.center.equalToSuperview()
                }
                UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(options)), animations: {
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
}

extension CLPopupTwoInputController {
    @objc func fristTapViewAction() {
        DispatchQueue.main.async {
            if self.type == .bloodSugar {
                self.view.endEditing(true)
                CLPopoverManager.showYearMonthDayHourMinuteDataPicker(yearMonthDayHourMinuteCallback: { [weak self] year, month, day, hour, minute in
                    self?.fristTextField.text = "\(year)年\(month)月\(day)日\(hour)时\(minute)分"
                })
            } else {
                self.fristTextField.becomeFirstResponder()
            }
        }
    }

    @objc func secondTapViewAction() {
        DispatchQueue.main.async {
            self.secondTextField.becomeFirstResponder()
        }
    }

    @objc func sureAction() {
        isDismiss = true
        sureCallback?(fristTextField.text, secondTextField.text)
        closeAction()
    }

    @objc func closeAction() {
        isDismiss = true
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
        CLPopoverManager.dismiss(key)
    }
}

extension CLPopupTwoInputController: CLPopoverProtocol {
    func showAnimation(completion: (() -> Void)?) {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        contentView.snp.remakeConstraints { make in
            make.left.equalTo(36)
            make.right.equalTo(-36)
            make.center.equalToSuperview()
        }
        UIView.animate(withDuration: 0.35) {
            self.view.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.40)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }

    func dismissAnimation(completion: (() -> Void)?) {
        contentView.snp.remakeConstraints { make in
            make.left.equalTo(36)
            make.right.equalTo(-36)
            make.bottom.equalTo(view.snp.top)
        }
        UIView.animate(withDuration: 0.35, animations: {
            self.view.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.00)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }) { _ in
            completion?()
        }
    }
}
