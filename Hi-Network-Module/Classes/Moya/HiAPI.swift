//
//  API.swift
//  OLMovie
//
//  Created by stone on 2019/8/30.
//  Copyright © 2019 Stone. All rights reserved.
//

import Moya
import SwiftyJSON

struct HiAPI {
    static func request(
        Authos:String,
        _ target: HiApiConfig,
        success successCallback: @escaping (JSON) -> Void,
        error errorCallback: @escaping (String) -> Void,
        failure failureCallback: @escaping (MoyaError) -> Void
        ) {
        MoyaProvider<HiApiConfig>(plugins: [HiAuthPlugin(token: Authos)]).request(target) { result in
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
}
