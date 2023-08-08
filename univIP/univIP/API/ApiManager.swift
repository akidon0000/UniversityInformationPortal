//
//  ApiManager.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/11/05.
//


import APIKit
import Foundation
import RxSwift
import SwiftyJSON

protocol InitialConfigurationAPIInterface {
    func getInitialConfiguration() -> Single<InitialConfigurationGetRequest.Response>
}

struct InitialConfigurationAPI: InitialConfigurationAPIInterface {
    func getInitialConfiguration() -> RxSwift.Single<InitialConfigurationGetRequest.Response> {
        let request = InitialConfigurationGetRequest()
        return .create { observer in
            let session = Session.send(request) { result in
                switch result {
                case let .success(response):
                    observer(.success(response))
                case let .failure(error):
                    observer(.failure(error))
                }
            }

            return Disposables.create {
                session?.cancel()
            }
        }
    }
}

struct InitialConfigurationGetRequest: Request {
    struct ResponseBody: Decodable {
        let items: [AdItem]
        init(object: Any) throws {
            guard let dictionary = object as? [String: Any],
                  let itemsArray = dictionary["items"] as? [[String: Any]] else {
                throw ResponseError.unexpectedObject(object)
            }
            var items: [AdItem] = []
            for item in itemsArray {
                guard let id = item["id"] as? Int,
                      let clientName = item["clientName"] as? String,
                      let imageUrlStr = item["imageUrlStr"] as? String,
                      let targetUrlStr = item["targetUrlStr"] as? String,
                      let imageDescription = item["imageDescription"] as? String else {
                    throw ResponseError.unexpectedObject(object)
                }
                let item = AdItem(id: id,
                                  clientName: clientName,
                                  imageUrlStr: imageUrlStr,
                                  targetUrlStr: targetUrlStr,
                                  imageDescription: imageDescription)
                items.append(item)
            }

            self.items = items
        }
    }

    typealias Response = ResponseBody

    var baseURL: URL {
        return URL(string: "https://tokudai0000.github.io")!
    }

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "/tokumemo_resource/api/v1/ad_items.json"
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let items = try Response(object: object)
        print(items.items)

        return try Response(object: object)
//        print(try decoder.decode(ResponseBody.self, from: object as! Data))
//        return try decoder.decode(ResponseBody.self, from: object as! Data)
//        if let jsonData = object.data(using: String.Encoding.utf8) {
//            let decoder = JSONDecoder()
//            do {
//                let response = try decoder.decode(ResponseBody.self, from: jsonData)
//                print(response.items) // Optional("test")
//            } catch {
//                print(error) // エラーを出力
//            }
//        }
//        print(object["items"])
//        guard let response = object as? ResponseBody else {
//            throw ResponseError.unexpectedObject(object)
//        }
//        return response
    }

//    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
//        // ResponseがDecodableに準拠していなければパースされない
//        guard let response = object as? Response else {
//            throw ResponseError.unexpectedObject(object)
//        }
//        return response
//    }
}


//import Foundation
//import Network
//import Alamofire
//import SwiftyJSON
//
///// 通信タイムアウト時間　（方式設計指定値  リクエスト:30s　レスポンス:60s）
//let API_TIMEOUT: TimeInterval = 10.0
//let API_RESPONSE_TIMEOUT: TimeInterval = 10.0
///// HTTPステータス有効(成功)範囲
//let API_HTTP_VALIDATE_STATUS = 200..<201
//
///// APIエラー
//public enum ApiError: Error {
//    case none               // なし（正常）
//    case notAvailable       // 通信不可
//    case timeout            // タイムアウト
//    case invalidURL         // URL不正
//    case badResponse        // 応答不正
//    case unknown(String)    // 未知
//    case alert(String)      // アラート表示
//}
//
////MARK: - リクエスト・ベースクラス
//
//protocol ApiRequest: Codable {
//    /// JSON-Dictionaryを返却
//    ///
//    /// - Returns: JSON-Dictionary
//    func toDict() -> [String: Any]?
//
//    /// JSON-Dataを返却
//    ///
//    /// - Returns: JSON-Data
//    func toData() -> Data?
//}
//
//extension ApiRequest {
//    /// JSON-Dictionaryを返却
//    ///
//    /// - Returns: JSON-Dictionary
//    func toDict() -> [String: Any]? {
//        do {
//            return try JSONSerialization.jsonObject(with: toData()!, options: .allowFragments) as? [String: Any]
//        } catch (let error) {
//            AKLog(level: .ERROR, message: "[API] JSONSerialization Error:\(error)")
//            return nil
//        }
//    }
//
//    /// JSON-Dataを返却
//    ///
//    /// - Returns: JSON-Data
//    func toData() -> Data? {
//        do {
//            return try JSONEncoder().encode(self)
//        } catch (let error) {
//            AKLog(level: .ERROR, message: "[API] JSONEncoder Error:\(error)")
//            return nil
//        }
//    }
//}
//
//class ApiManager: NSObject {
//
//    // MARK: - Public value
//    static let singleton = ApiManager() // シングルトン・インタンス
//
//    // ネットワーク接続状態
//    private var isConnected = false
//
//    // タイムアウト設定
//    let manager = Alamofire.SessionManager.default
//    let headers: HTTPHeaders = ["Content-Type": "application/json"]
//
//    /// シングルトン・インスタンスの初期処理
//    private override init() {  //シングルトン保証// privateにすることにより他から初期化させない
//        super.init()
//
//        // ネットワーク接続状態のモニタリング
//        let monitor = NWPathMonitor()
//        monitor.pathUpdateHandler = { [weak self] path in
//            if path.status == .satisfied {
//                // Connect
//                self?.isConnected = true
//            } else {
//                // Disconnect
//                self?.isConnected = false
//                AKLog(level: .WARN, message: "[Network] Disconnect")
//            }
//        }
//        let queue = DispatchQueue(label: "com.akidon0000.queue")
//        monitor.start(queue: queue)
//    }
//}
//
//extension ApiManager {
//    public func request(_ urlStr: String,
//                        success: @escaping (_ response: JSON) -> (),
//                        failure: @escaping (_ error: ApiError) -> ()) {
//
//        AKLog(level: .DEBUG, message: "\(urlStr)")
//
//        manager.session.configuration.timeoutIntervalForRequest = API_TIMEOUT // リクエスト開始まで
//        manager.session.configuration.timeoutIntervalForResource = API_RESPONSE_TIMEOUT // リクエスト開始からレスポンス終了まで
//
//        manager.request(urlStr).responseJSON { response in
//            guard let object = response.result.value else {
//                failure(ApiError.none)
//                return
//            }
//            success(JSON(object))
//            return
//        }
//    }
//}
