//
//  FavoriteViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/02/16.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var favoriteNameTextField: UITextField!
    
    @IBOutlet weak var urlUnderLine: UIView!
    @IBOutlet weak var favoriteNameUnderLine: UIView!
    
    @IBOutlet weak var urlMessageLabel: UILabel!
    @IBOutlet weak var favoriteNameMessageLabel: UILabel!
    
    @IBOutlet weak var favoriteTextSizeLabel: UILabel!
    
    @IBOutlet weak var isFirstViewSetting: UISwitch!
    @IBOutlet weak var registerButton: UIButton!
    
    public var urlString: String?
    private let dataManager = DataManager.singleton
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlTextFieldCursorSetup(type: .normal)
        favoriteNameTextFieldCursorSetup(type: .normal)
        
        favoriteNameTextField.borderStyle = .none
        
        favoriteNameTextField.delegate = self
        
        guard let urlString = urlString else { return }
        urlLabel.text = urlString
        
        favoriteTextSizeLabel.text = "0/10"
        
        urlMessageLabel.textColor = .red
        favoriteNameMessageLabel.textColor = .red
        
        registerButton.layer.cornerRadius = 5.0
        
        
        // 多分ここが通ることはないが念の為
        guard let _ = URL(string: urlString) else {
            urlMessageLabel.text = "不正なURLです"
            urlTextFieldCursorSetup(type: .error)
            return
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // キーボードの通知セット
        let notification = NotificationCenter.default
        // キーボードが現れる直前呼び出す
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                 name: UIResponder.keyboardWillShowNotification, object: nil)
        // キーボードが隠れる直前呼び出す
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                 name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - IBAction
    @IBAction func registerButton(_ sender: Any) {
        // textField.textはnilにはならずOptional("")となる(objective-c仕様の名残)
        guard let favoriteNameText = favoriteNameTextField.text else { return }
        
        if favoriteNameText.isEmpty {
            favoriteNameMessageLabel.text = "空欄です"
            favoriteNameTextFieldCursorSetup(type: .error)
            return
        }
        
        // 初期画面に設定した場合
        if isFirstViewSetting.isOn {
            // 既存のリストのisInitViewを全てfalseに(実際にはどれか1つのみのtrueをfalseにするだけ)
            var menuLists = dataManager.menuLists
            for i in 0..<menuLists.count {
                menuLists[i].isInitView = false
            }
            dataManager.menuLists = menuLists
            // menuListsをUserDefaultsに保存
            dataManager.saveMenuLists()
        }
        
        // お気に入りの仕様を作成
        let menuItem = Constant.Menu(title: favoriteNameText,
                                     id: .favorite,
                                     url: urlString,
                                     isInitView: isFirstViewSetting.isOn,
                                     canInitView: true)
        // 保存
        dataManager.addContentsMenuLists(menuItem: menuItem)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Private
    
    enum cursorType {
        case normal
        case focus
        case error
    }
    private func urlTextFieldCursorSetup(type: cursorType) {
        switch type {
                
            case .normal:
                urlUnderLine.backgroundColor = .lightGray
                
            case .focus:
                // カーソルの色
                urlLabel.tintColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                urlUnderLine.backgroundColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                
            case .error:
                urlLabel.tintColor = .red
                urlUnderLine.backgroundColor = .red
        }
    }
    
    private func favoriteNameTextFieldCursorSetup(type: cursorType) {
        switch type {
                
            case .normal:
                favoriteNameUnderLine.backgroundColor = .lightGray
                
            case .focus:
                favoriteNameTextField.tintColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                favoriteNameUnderLine.backgroundColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                
            case .error:
                favoriteNameTextField.tintColor = .red
                favoriteNameUnderLine.backgroundColor = .red
        }
    }
    
}


// MARK: - UITextFieldDelegate
extension FavoriteViewController: UITextFieldDelegate {
    
    // textField編集前
    func textFieldDidBeginEditing(_ textField: UITextField) {
        favoriteNameTextFieldCursorSetup(type: .focus)
    }
    // textField編集後
    func textFieldDidEndEditing(_ textField: UITextField) {
        favoriteNameTextFieldCursorSetup(type: .normal)
    }
    
    // text内容が変更されるたびに
    func textFieldDidChangeSelection(_ textField: UITextField) {
        favoriteTextSizeLabel.text = "\(favoriteNameTextField.text?.count ?? 0)/10"
    }
    
}


// キーボード関連
extension FavoriteViewController {
    // キーボードが現れる直前に呼ばれる
    @objc func keyboardWillShow(notification: Notification?) {
        // UIKeyboardWillShowNotification を取得
        guard let notification = notification else {
            AKLog(level: .ERROR, message: "[notification取得エラー]")
            return
        }
        // キーボード関連の情報
        guard let userInfo = notification.userInfo as? [String: Any] else {
            AKLog(level: .ERROR, message: "[userInfo取得エラー]")
            return
        }
        // キーボードの表示範囲
        // NSRect{{x, y}, {wide, hight}}
        guard let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            AKLog(level: .ERROR, message: "[keyboardInfo取得エラー]")
            return
        }
        // キーボード表示アニメーション時間
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            AKLog(level: .ERROR, message: "[duration取得エラー]")
            return
        }
        
        // キーボードで隠れた高さ
        let hideY = -keyboardInfo.cgRectValue.size.height
        
        UIView.animate(withDuration: duration + 0.2, animations: { () in
            let transform = CGAffineTransform(translationX: 0, y: hideY)
            self.registerButton.transform = transform
        })
    }
    
    // キーボードが隠れる直前呼ばれる
    @objc func keyboardWillHide(notification: Notification?) {
        // 画面全体を元に戻す
        // UIKeyboardWillShowNotification を取得
        guard let notification = notification else {
            AKLog(level: .ERROR, message: "[notification取得エラー]")
            return
        }
        // キーボード関連の情報
        guard let userInfo = notification.userInfo as? [String: Any] else {
            AKLog(level: .ERROR, message: "[userInfo取得エラー]")
            return
        }
        // キーボード表示アニメーション時間
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            AKLog(level: .ERROR, message: "[duration取得エラー]")
            return
        }
        
        UIView.animate(withDuration: duration + 0.2, animations: { () in
            self.registerButton.transform = CGAffineTransform.identity
        })
    }
    
    // キーボードを非表示
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
