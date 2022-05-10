//
//  .swift
//  Hi-Network-Module
//
//  Created by stone on 2022/5/10.
//

import Moya
import Result
import SwiftyJSON
import MBProgressHUD
import Hi_Helper_Module

protocol HiApiConfigTargetType: TargetType {
    //是否需要添加loading:
    var needLoading: Bool { get }
    //是否需要加密:
    var needEncypted: Bool { get }
    //是否需要打印请求体:
    var needLogRequest: Bool { get }
    //是否需要打印响应体:
    var needLogResponse: Bool { get }
}

struct HiApiConfigPlugin: PluginType {
    
    var configTarget:HiApiConfig?;
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        //判断该请求是否需要Loading
        self.logRequest(request:request);
        guard let needLoading = configTarget?.needLoading, needLoading else {
            return request;
        }
        let vc:UIViewController = HiPageHelper.fetchCurrentController() ?? UIViewController();
        HiHudToast.showHUD(ctrl: vc);
        var request = request;
        request.addValue("this is a accessToken", forHTTPHeaderField: "accessToken");
        return request
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        self.logResponse(result: result);
        guard let needLoading = configTarget?.needLoading,needLoading else {
            return;
        }
        let vc:UIViewController = HiPageHelper.fetchCurrentController() ?? UIViewController();
        HiHudToast.hideHUD(ctrl: vc);
    }
    
    func logRequest(request: URLRequest) {
        guard let needLogRequest = configTarget?.needLogRequest,needLogRequest else {
            return;
        }
        if let requestData = request.httpBody {
            print("请求地址：\(request.url!)" + "\n" + "请求方式：\(request.httpMethod ?? "")" + "\n" + "请求参数：" + "\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        } else {
            print("请求地址：\(request.url!)" + "\n" + "请求方式：\(String(describing: request.httpMethod!))")
        }
        if let header = request.allHTTPHeaderFields {
            print("请求头内容：\(header)")
        }
    }
    
    func logResponse(result: Result<Response, MoyaError>) {
        guard let needLogResponse = configTarget?.needLogResponse,needLogResponse else {
            return;
        }
        switch result {
        case let .success(response):
            do {
                //如果数据返回成功则直接将结果转为JSON
                try response.filterSuccessfulStatusCodes()
                let json = try JSON(response.mapJSON())
                print("响应内容：\(json)");
            }
            catch let error {
                //如果数据获取失败，则返回错误状态码
                print("响应内容：\(error)")
            }
        case let .failure(error):
            //如果连接异常，则返回错误信息（必要时还可以将尝试重新发起请求）
            print("响应内容：\(error)")
        }
    }
}
