//
//  ServerHelper.swift
//  SaitamaBicycle
//
//  Created by luan on 7/17/16.
//  Copyright © 2016 luantran. All rights reserved.
//

import Foundation
import Alamofire

let accessTokenKeychain = "accessToken"

protocol ServerHelperGetPlaceDelegate: class {
    func ServerGetPlaceSuccess(places: [BicyclePlace])
}

class ServerHelper {
    // MARK: Data
    var places = [BicyclePlace]()
    weak var delegate: ServerHelperGetPlaceDelegate?
    
    // MARK: Instance
    static let sharedInstance = ServerHelper()
    
    // MARK: Server Define
    struct ServerDefine {
        static let apiURL = "http://localhost:8080"
        
        static let loginEndPoint = "/api/v1/auth"
        static let registerEndPoint = "/api/v1/register"
        static let placesEndPoint = "/api/v1/places"
        static let paymentEndPoint = "/api/v1/rent"
        
        static let emailKey = "email"
        static let passwordKey = "password"
        static let tokenKey = "accessToken"
        
        static let resultKey = "results"
        static let locationKey = "location"
        static let latKey = "lat"
        static let lngKey = "lng"
        static let idKey = "id"
        static let nameKey = "name"
    }
    
    // MARK: do Login
    
    func doLogin(username: String, password: String) {
        let url = ServerDefine.apiURL + ServerDefine.loginEndPoint
        let parameters = [ ServerDefine.emailKey: username,
                           ServerDefine.passwordKey: password ]
        
        Alamofire.request(.POST, url, parameters: parameters)
                 .responseJSON { response in
                    print(response.request)
                    print(response.response)
                    print(response.data)
                    print(response.result)
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        if let dictionary = JSON as? [String: AnyObject], accessToken = dictionary[accessTokenKeychain] as? String {
                            KeychainWrapper.setString(accessToken, forKey: accessTokenKeychain)
                        }
                    }
        }
    }
    
    // MARK: do register
    func doRegister(username: String, password: String, completition: ((Bool) -> Void)) {
        let url = ServerDefine.apiURL + ServerDefine.registerEndPoint
        let parameters = [ ServerDefine.emailKey: username,
                           ServerDefine.passwordKey: password ]
        
        Alamofire.request(.POST, url, parameters: parameters)
            .responseJSON { response in
                print("request: \(response.request)")
                print("Response: \(response.response)")
                print("Data: \(response.data)")
                print("Result: \(response.result)")
                
                if let JSON = response.result.value, dictionary = JSON as? [String: AnyObject], accessToken = dictionary[accessTokenKeychain] as? String {
                    print("JSON: \(JSON)")
                    
                    KeychainWrapper.setString(accessToken, forKey: accessTokenKeychain)
                    self.getAllCycles()
                    completition(true)
                } else {
                    completition(false)
                }
        }
    }
    
    // MARK: get all cycle
    func getAllCycles() {
        guard let authorization = KeychainWrapper.stringForKey(accessTokenKeychain) else {
            return
        }
        
        let url = ServerDefine.apiURL + ServerDefine.placesEndPoint
        let headers = [ "Authorization": authorization ]
        Alamofire.request(.GET, url, parameters: nil, headers: headers)
                 .responseJSON { response in
                    print("request: \(response.request)")
                    print("Response: \(response.response)")
                    print("Data: \(response.data)")
                    print("Result: \(response.result)")
                    
                    if let JSON = response.result.value, dictionary = JSON as? [String: AnyObject] {
                        print("JSON: \(JSON)")
                        self.parseDictionary(dictionary)
                        self.delegate?.ServerGetPlaceSuccess(self.places)
                    } else {
                    }
        }
    }
    
    private func parseDictionary(dictionary: [String: AnyObject]) {
        guard let array = dictionary[ServerDefine.resultKey] as? [AnyObject] else {
            print("Not 'results' format")
            return
        }
        
        for placeArray in array {
            if let placeArray = placeArray as? [String: AnyObject] {
                if let place = BicyclePlace(dictionary: placeArray) {
                    places.append(place)
                }
            }
        }
    }
}