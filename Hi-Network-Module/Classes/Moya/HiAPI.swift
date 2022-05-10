//
//  API.swift
//  OLMovie
//
//  Created by stone on 2019/8/30.
//  Copyright © 2019 Stone. All rights reserved.
//

import Moya
import SwiftyJSON

///超时时长
private var requestTimeOut: Double = 30

/// 网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
private let endpointClosure = {(target: TargetType) -> Endpoint in
   let url = target.baseURL.absoluteString + target.path
   var task = target.task
   var endPoint = Endpoint(url: url,
                           sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                           method: target.method,
                           task: task,
                           httpHeaderFields: target.headers)
   if let apiTarget = target as? MultiTarget,
      let target = apiTarget.target as? HiApiConfig  {
       switch target {
       case .fetchPostMethod(_):
           requestTimeOut = 20
           return endPoint
       default:
           return endPoint
       }
   }
   return endPoint
}

/// 网络请求的设置:
private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
   do {
       var request = try endpoint.urlRequest()
       request.timeoutInterval = requestTimeOut;
       done(.success(request))
   } catch {
       done(.failure(MoyaError.underlying(error, nil)))
   }
}

private let networkPlugin = NetworkActivityPlugin.init { changeType, _ in
   // targetType 是当前请求的基本信息
//   switch changeType {
//   case .began:
//       print("开始请求网络")
//   case .ended:
//       print("结束")
//   }
}

public struct HiAPI {
    
    public static func request(
        _ target: HiApiConfig,
        success successCallback: @escaping (JSON) -> Void,
        error errorCallback: @escaping (String) -> Void,
        failure failureCallback: @escaping (MoyaError) -> Void
        ) {
            MoyaProvider<MultiTarget>(endpointClosure: endpointClosure, requestClosure: requestClosure, plugins: [networkPlugin,HiApiConfigPlugin(configTarget: target)], trackInflights: false).request(MultiTarget(target as! TargetType)) { result in
            switch result {
            case let .success(response):
                do {
                    //如果数据返回成功则直接将结果转为JSON
                    try response.filterSuccessfulStatusCodes()
                    let json = try JSON(response.mapJSON())
                    successCallback(json)
                }
                catch let error {
                    //如果数据获取失败，则返回错误状态码
                    errorCallback((error as! MoyaError).response!.description)
                }
            case let .failure(error):
                //如果连接异常，则返回错误信息（必要时还可以将尝试重新发起请求）
                failureCallback(error)
            }
        }
    }
    
    
//    public static var shared: HiAPI {
//        struct Static {
//            static let sharedInstance = HiAPI()
//        }
//        return Static.sharedInstance;
//    }
//    lazy var hud: MBProgressHUD = {[self] in
//        let vc:UIViewController = HiPageHelper.fetchCurrentController() ?? UIViewController();
//        let hud = MBProgressHUD.showAdded(to: vc.view, animated: true);
//        hud.mode = .indeterminate;
//        hud.label.text = "加载中..."
//        return hud
//    }()
}
