//
//  AuthPlugin.swift
//  OLMovie
//
//  Created by stone on 2019/8/30.
//  Copyright © 2019 Stone. All rights reserved.
//

import Moya

protocol AuthorizedTargetType: TargetType {
    //返回是否需要授权
    var needsAuth: Bool { get }
}

struct HiAuthPlugin: PluginType {
    //令牌字符串
    let token: String
    //准备发起请求
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        //判断该请求是否需要授权
        guard
            let target = target as? AuthorizedTargetType,
            target.needsAuth
            else {
                return request
        }
        var request = request
        request.timeoutInterval = 5   //设置请求超时时间
        return request
    }
}
