//
//  WebViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/12.
//

import UIKit
import WebKit
import RxSwift
import StoreKit

final class WebViewController: UIViewController {
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var urlLabel: UILabel!
    @IBOutlet private weak var reloadButton: UIButton!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var goForwardButton: UIButton!
    @IBOutlet private weak var goBackButton: UIButton!
    @IBOutlet private weak var safariButton: UIButton!
    @IBOutlet private weak var menuButton: UIButton!

    private let disposeBag = DisposeBag()
    
    var viewModel: WebViewModelInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDefaults()
        configureWebView()
        binding()
        viewModel.input.viewDidLoad.accept(())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.viewWillAppear.accept(())
    }
}

// MARK: Binding
private extension WebViewController {
    func binding() {
        closeButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.viewClose.accept(())
            }
            .disposed(by: disposeBag)

        reloadButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.webView.reload()
            }
            .disposed(by: disposeBag)

        goForwardButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.webView.goForward()
            }
            .disposed(by: disposeBag)

        goBackButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                // 戻るサイトが無い場合は、画面を削除
                if owner.webView.canGoBack {
                    owner.webView.goBack()
                } else {
                    owner.viewModel.input.viewClose.accept(())
                }
            }
            .disposed(by: disposeBag)

        safariButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.didTapSafariButton.accept(())
            }
            .disposed(by: disposeBag)

        viewModel.output
            .urlLabel
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, urlStr in
                owner.urlLabel.text = urlStr
            }
            .disposed(by: disposeBag)

        viewModel.output
            .loadUrl
            .asDriver(onErrorJustReturn: Url.emptyRequest.urlRequest())
            .drive(with: self) { owner, urlRequest in
                owner.webView.load(urlRequest)
            }
            .disposed(by: disposeBag)

        viewModel.output
            .reloadLoginURLInWebView
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.webView.load(Url.universityTransitionLogin.urlRequest())
            }
            .disposed(by: disposeBag)

        viewModel.output
            .skipReminderJavaScriptInjection
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
            }
            .disposed(by: disposeBag)

        viewModel.output
            .loginJavaScriptInjection
            .asDriver(onErrorJustReturn: UnivAuth(accountCID: "", password: ""))
            .drive(with: self) { owner, univAuth in
                owner.webView.evaluateJavaScript("document.getElementById('username').value= '\(univAuth.accountCID)'", completionHandler:  nil)
                owner.webView.evaluateJavaScript("document.getElementById('password').value= '\(univAuth.password)'", completionHandler:  nil)
                owner.webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
            }
            .disposed(by: disposeBag)

        viewModel.output
            .loginOutlookJavaScriptInjection
            .asDriver(onErrorJustReturn: UnivAuth(accountCID: "", password: ""))
            .drive(with: self) { owner, univAuth in
                owner.webView.evaluateJavaScript("document.getElementById('userNameInput').value='\(univAuth.accountCID)@tokushima-u.ac.jp'", completionHandler:  nil)
                owner.webView.evaluateJavaScript("document.getElementById('passwordInput').value='\(univAuth.password)'", completionHandler:  nil)
            }
            .disposed(by: disposeBag)

        viewModel.output
            .loginCareerCenterJavaScriptInjection
            .asDriver(onErrorJustReturn: UnivAuth(accountCID: "", password: ""))
            .drive(with: self) { owner, univAuth in
                owner.webView.evaluateJavaScript("document.getElementsByName('user_id')[0].value='\(univAuth.accountCID)'", completionHandler:  nil)
                owner.webView.evaluateJavaScript("document.getElementsByName('user_password')[0].value='\(univAuth.password)'", completionHandler:  nil)
            }
            .disposed(by: disposeBag)

        viewModel.output
            .openSafari
            .asDriver(onErrorJustReturn: Url.privacyPolicy.urlRequest())
            .drive(with: self) { owner, urlRequest in
                guard let url = urlRequest.url else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            .disposed(by: disposeBag)

        viewModel.output
            .showReviewAlert
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                // レビュー依頼を行う
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: windowScene)
                    }
                }
            }
            .disposed(by: disposeBag)

        viewModel.output
            .changeWebViewZoomLevel
            .asDriver(onErrorJustReturn: "1")
            .drive(with: self) { owner, level in
                owner.webView.evaluateJavaScript("document.body.style.zoom = \(level);", completionHandler: nil)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Layout
private extension WebViewController {

    func configureDefaults() {
//        goForwardButton.alpha = 0.6
    }
    
    func configureWebView() {
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
}

extension WebViewController: WKNavigationDelegate, WKUIDelegate {
    // リクエスト前
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        viewModel.input.urlPendingLoad.accept(url)
        decisionHandler(.allow)
    }

    // レスポンス取得後
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }

    // 読み込み完了後
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = self.webView.url{
            viewModel.input.urlDidLoad.accept(url)
        }
    }

    /// alert対応
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default) { action in completionHandler() }
        alertController.addAction(otherAction)
        present(alertController, animated: true, completion: nil)
    }

    /// confirm対応
    /// 確認画面、イメージは「この内容で保存しますか？はい・いいえ」のようなもの
    func webView(_ webView: WKWebView,
                 runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in completionHandler(false) }
        let okAction = UIAlertAction(title: "OK", style: .default) { action in completionHandler(true) }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    /// prompt対応
    /// 入力ダイアログ、Alertのtext入力できる版
    func webView(_ webView: WKWebView,
                 runJavaScriptTextInputPanelWithPrompt prompt: String,
                 defaultText: String?,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        let okHandler: () -> Void = {
            if let textField = alertController.textFields?.first {
                completionHandler(textField.text)
            }else{
                completionHandler("")
            }
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { action in okHandler() }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in completionHandler("") }
        alertController.addTextField() { $0.text = defaultText }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    /// target="_blank"(新しいタブで開く) の処理
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        // 新しいタブで開くURLを取得し、読み込む
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

//extension WebViewController {
//
//    /// トースト表示
//    ///
//    /// - Parameters:
//    ///   - message: メッセージ
//    ///   - interval: 表示時間（秒）デフォルト3秒
//    public func toast( message: String, type: String = "highBottom", interval:TimeInterval = 3.0 ) {
//        guard self.toastView == nil else {
//            return // 既に表示準備中
//        }
//        self.toastView = UIView()
//        guard let toastView = self.toastView else { // アンラッピング
//            return
//        }
//
//        toastInterval = interval
//
//        switch type {
//        case "top":
//            toastShowFrame = CGRect(x: 15,
//                                    y: 8,
//                                    width: self.view.frame.width - 15 - 15,
//                                    height: 46)
//
//            toastHideFrame = CGRect(x: toastShowFrame.origin.x,
//                                    y: 0 - toastShowFrame.height * 2,  // 上に隠す
//                                    width: toastShowFrame.width,
//                                    height: toastShowFrame.height)
//
//        case "bottom":
//            toastShowFrame = CGRect(x: 15,
//                                    y: self.view.frame.height - 100,
//                                    width: self.view.frame.width - 15 - 15,
//                                    height: 46)
//
//            toastHideFrame = CGRect(x: toastShowFrame.origin.x,
//                                    y: self.view.frame.height - toastShowFrame.height * 2,  // 上に隠す
//                                    width: toastShowFrame.width,
//                                    height: toastShowFrame.height)
//
//        case "highBottom":
//            toastShowFrame = CGRect(x: 15,
//                                    y: self.view.frame.height - 180,
//                                    width: self.view.frame.width - 15 - 15,
//                                    height: 46)
//
//            toastHideFrame = CGRect(x: toastShowFrame.origin.x,
//                                    y: self.view.frame.height - toastShowFrame.height * 2,  // 上に隠す
//                                    width: toastShowFrame.width,
//                                    height: toastShowFrame.height)
//        default:
//            return
//        }
//        toastView.frame = toastHideFrame  // 初期隠す位置
//        toastView.backgroundColor = UIColor.black
//        toastView.alpha = 0.8
//        toastView.layer.cornerRadius = 18
//        self.view.addSubview(toastView)
//
//        let labelWidth:CGFloat = toastView.frame.width - 14 - 14
//        let labelHeight:CGFloat = 19.0
//        let label = UILabel()
//        // toastView内に配置
//        label.frame = CGRect(x: 14,
//                             y: 14,
//                             width: labelWidth,
//                             height: labelHeight)
//        toastView.addSubview(label)
//        // label属性
//        label.textColor = UIColor.white
//        label.textAlignment = .left
//        label.numberOfLines = 0 // 複数行対応
//        label.text = message
//        //"label.frame1: \(label.frame)")
//        // 幅を制約して高さを求める
//        label.frame.size = label.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude))
//        //print("label.frame2: \(label.frame)")
//        // 複数行対応・高さ変化
//        if labelHeight < label.frame.height {
//            toastShowFrame.size.height += (label.frame.height - labelHeight)
//        }
//        didHideIndicator()
//    }
//    @objc private func didHideIndicator() {
//        guard let toastView = self.toastView else { // アンラッピング
//            return
//        }
//        DispatchQueue.main.async { // 非同期処理
//            UIView.animate(withDuration: 0.5, animations: { () in
//                // 出現
//                toastView.frame = self.toastShowFrame
//            }) { (result) in
//                // 出現後、interval(秒)待って、
//                DispatchQueue.main.asyncAfter(deadline: .now() + self.toastInterval) {
//                    UIView.animate(withDuration: 0.5, animations: { () in
//                        // 消去
//                        toastView.frame = self.toastHideFrame
//                    }) { (result) in
//                        // 破棄
//                        toastView.removeFromSuperview()
//                        self.toastView = nil // 破棄
//                    }
//                }
//            }
//        }
//    }
//}
