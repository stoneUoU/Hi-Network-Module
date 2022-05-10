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
    
    case fetchGetMethod([String : Any])
    
    case fetchPostMethod([String : Any])
    
    //获取app的基本配置信息：
    case fetchBaseInfo(Void)
    
    //获取首页导航栏数据：
    case fetchNavigationData(Void)
    
    //获取首页信息：
    case fetchHomeData([String : Any])
    
    //获取unitCfg接口数据：
    case fetchUnitCfg([String : Any])
}

//请求配置
extension HiApiConfig:HiApiConfigTargetType {
    //服务器地址
    public var baseURL: URL {
        switch self {
            case .fetchUnitCfg(_):
                return URL(string: HiHSARequestSwiftURL)!
            default:
                return URL(string: HiRequestSwiftURL)!
        }
    }
    //各个请求的具体路径
    public var path: String {
        switch self {
        case .fetchGetMethod(_):
            return ""
        case .fetchPostMethod(_):
            return ""
        case .fetchBaseInfo(_):
            return "/provide/baseinfo"
        case .fetchNavigationData(_):
            return "/provide/home_nav"
        case .fetchHomeData(_):
            return "/vod/top2"
        case .fetchUnitCfg(_):
            return "/base/api/unitCfg"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .fetchGetMethod(_),.fetchBaseInfo(_),.fetchNavigationData(_):
            return .get
        default:
            return .post
        }
    }
        
    public var task: Task {
        switch self {
        //get 走这
        case .fetchGetMethod(let paras):
            var params: [String: Any] = [:]
            params = paras
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        //post 走这
        case .fetchPostMethod(let  paras),.fetchHomeData(let paras):
            var params: [String: Any] = [:]
            params = paras
            return .requestParameters(parameters: params,
                                      encoding: JSONEncoding.default)
        case .fetchUnitCfg(let paras):
            var params: [String: Any] = ["appId":"19E179E5DC29C05E65B90CDE57A1C7E5","encType":"plain","signType":"plain","timestamp":"1652165413","transType":"ec.queryCode","version":"1.0.0"];
            params["data"] = paras
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
        return [
            "Content-Type": "application/json",
            "Accept-Language": "zh-Hans-CN;q=1, en-CN;q=0.9",
            "User-Agent": "HealthCommunity/1.3.7 (iPhone; iOS 15.4.1; Scale/2.00)",
            "appId": "19E179E5DC29C05E65B90CDE57A1C7E5",
            "appVersion": "1.3.7",
            "channel": "app",
            "operateSystem": "iOS",
            "operateSystemVersion": "15.4.1",
            "x-tif-nonce": "15.4.1",
            "x-tif-paasid": "sn7LxDszc7Ib4bOB",
            "x-tif-signature": "a6ce2d32664636b8383a64017105e8ab9cd71975f543b9b437469aa3d444d4a2",
            "x-tif-timestamp": "1652165413"
        ]
    }
    
    //是否需要Loading
    public var needLoading: Bool {
        switch self {
        case .fetchGetMethod(_),.fetchHomeData(_):
            return true
        default:
            return false
        }
    }
    
    //是否需要加密:
    public var needEncypted: Bool {
        switch self {
        case .fetchGetMethod(_),.fetchHomeData(_):
            return true
        default:
            return false
        }
    }
    
    //是否需要打印请求体:
    public var needLogRequest: Bool {
        switch self {
        case .fetchGetMethod(_),.fetchHomeData(_):
            return false
        default:
            return true
        }
    }
    
    //是否需要打印响应体:
    public var needLogResponse: Bool {
        switch self {
        case .fetchGetMethod(_),.fetchHomeData(_),.fetchUnitCfg(_):
            return true
        default:
            return false
        }
    }
}
