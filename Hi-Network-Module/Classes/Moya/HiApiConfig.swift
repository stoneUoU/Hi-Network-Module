//
//  HiApiConfig.swift
//  OLMovie
//
//  Created by stone on 2019/8/30.
//  Copyright © 2019 Stone. All rights reserved.
//

import Moya
//请求分类
public enum HiApiConfig {
    
    case toGetMethod([String : Any])
    
    case toPostMethod([String : Any])
}

//请求配置
extension HiApiConfig: AuthorizedTargetType {
    //服务器地址
    public var baseURL: URL {
        return URL(string: "")!
    }
    //各个请求的具体路径
    public var path: String {
        switch self {
        case .toGetMethod(_):
            return ""
        case .toPostMethod(_):
            return ""
        }
    }
    public var method: Moya.Method {
        switch self {
        case .toGetMethod(_):
            return .get
        default:
            return .post
        }
    }
        
    public var task: Task {
        switch self {
        //get 走这
        case .toGetMethod(let paras):
            var params: [String: Any] = [:]
            params = paras
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        //post 走这
        case .toPostMethod(let  paras):
            var params: [String: Any] = [:]
            params = paras
            return .requestParameters(parameters: params,
                                      encoding: JSONEncoding.default)
        //没有请求参数走这
        default:
            return .requestPlain
        }
    }
    //是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    //请求头
    public var headers: [String: String]? {
        return nil
    }
    //是否需要授权
    public var needsAuth: Bool {
        switch self {
        case .toGetMethod(_):
            return false
        default:
            return true
        }
    }
}
