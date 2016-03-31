// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit
/*
import Alamofire

// MARK: - NBNetworkRequest -

public protocol NBNetworkRequest {
    
    typealias Response
    
    /// 使用するクエリオブジェクトを返却する(必須)
    func query() -> AnyObject
    
    /// APIからの戻り値を元にレスポンスを生成して返却する(必須)
    /// - parameter res: APIからの戻り値オブジェクト
    /// - returns: レスポンス
    func processResponse(res: AnyObject?) -> Response?
    
    /// リクエスト前にクエリに対して処理(パラメータの追加など)を施す(オプショナル)
    /// - parameter query: クエリオブジェクト
    /// - returns: 引数queryに対して何らかの処理をしたクエリオブジェクト
    func processQuery(query: GTLQueryDrive) -> GTLQueryDrive
    
    /// リクエスト前にサービスに対して処理(パラメータの追加など)を施す(オプショナル)
    /// - parameter service: サービスオブジェクト
    /// - returns: 引数serviceに対して何らかの処理をしたサービスオブジェクト
    func processService(service: GTLServiceDrive) -> GTLServiceDrive
    
    /// API結果のステータスを返却する(オプショナル)
    ///
    /// processResponse()時に何らかのエラー等があった場合に、
    /// このメソッドでFailedを返すことで、ハンドラ側にエラーを知らせることができます
    /// - returns: API結果ステータス
    func resultState() -> GoogleApiResultState
}
extension NBNetworkRequest {
    
    func processQuery(query: GTLQueryDrive) -> GTLQueryDrive { return query }
    
    func processService(service: GTLServiceDrive) -> GTLServiceDrive { return service }
    
    func resultState() -> GoogleApiResultState { return .Succeed }
}

// MARK: - NBNetworkResult -

/// ネットワークリクエストの結果ステータス
public enum NBNetworkResultStete {
    /// まだリクエストしていない状態
    case None
    /// 成功
    case Succeed
    /// 失敗
    case Failed(NSError)
    
    /// エラーオブジェクト(Failedの時だけ取得できる)
    public var error: NSError? {
        switch self {
        case let .Failed(err): return err
        default:               return nil
        }
    }
}

/// ネットワークリクエストの結果
public class NBNetworkResult: NSObject {
    
    /// 結果ステータス
    var state = NBNetworkResultStete.None
    
    public override var description: String {
        var ret = " \(super.description) \(self.state) "
        
//        if let ticket = self.ticket {
//            ret += "\(ticket.statusCode)"
//        }
        if let error = self.state.error {
            ret += " \(error.localizedDescription)"
        }
        
        return ret
    }
}

// MARK: - NBNetwork -

public class NBNetwork: NSObject {
    
    /// リクエストを送信する
    /// - parameter request: リクエストオブジェクト
    /// - parameter handler: レスポンスハンドラ
    public func request<T: NBNetworkRequest>(request: T, handler: (T.Response?, NBNetworkResult) -> Void) {
        
        let result = NBNetworkResult()
        
        // 認証チェック
        guard let authorizer = self.OAuth2 else {
            result.state = .Failed(self.errorWithMessage("not authorized."))
            handler(nil, result)
            return
        }
        // クエリオブジェクトのチェック
        guard let query = request.query() as? GTLQueryDrive else {
            result.state = .Failed(self.errorWithMessage("invalid query."))
            handler(nil, result)
            return
        }
        
        let service = GTLServiceDrive()
        service.authorizer = authorizer
        request.processService(service).executeQuery(request.processQuery(query)) { ticket, res, error in
            
            result.ticket = ticket
            
            var response: T.Response? = nil
            if let error = error {
                result.state = .Failed(error)
            } else {
                response = request.processResponse(res)
                result.state = request.resultState()
            }
            
            handler(response, result)
        }
        
        Alamofire.request(.GET, url).responseData { res in
            if let err = res.result.error {
                downloaded("\(err.localizedDescription). URL: '\(url)'"); return
            }
            guard let data = res.result.value, let image = UIImage(data: data) else {
                downloaded("responsed data is none, or data is invalid. URL: '\(url)'"); return
            }
            assets[index].image = image
            
            if ++index < max {
                downloadAsset(downloaded)
            } else {
                downloaded(nil)
            }
        }
    }
    
    /// エラーメッセージからエラーオブジェクトを生成する
    /// - parameter message: エラーメッセージ
    /// - parameter code: エラーコード
    /// - returns: エラーオブジェクト
    private func errorWithMessage(message: String, code: Int = -1) -> NSError {
        return NSError(domain: "GoogleApiErrorDomain", code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
*/
