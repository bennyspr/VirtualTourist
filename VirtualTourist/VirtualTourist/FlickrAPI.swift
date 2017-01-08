//
//  FlickrAPI.swift
//  VirtualTourist
//
//  Created by Benny on 4/3/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import Foundation


class FlickrAPI: RequestAPIProtocol {
    
    fileprivate let urlPath: FlickrPath!
    fileprivate var pathValues: [String: FlickrPath]?
    fileprivate var method: HTTPRequestMethod!
    
    var urlParameters: [String: AnyObject]?
    var json: NSDictionary?
    
    init(pathValue: String, httpMethod: HTTPRequestMethod = .GET) {
        self.urlPath = FlickrPath.None
        self.pathValues = [pathValue: FlickrPath.None]
        self.method = httpMethod
    }
    
    init(urlPath: FlickrPath, httpMethod: HTTPRequestMethod = .GET) {
        self.urlPath = urlPath
        self.pathValues = nil
        self.method = httpMethod
    }
    
    init(urlPath: FlickrPath, withValue pathValue: String, httpMethod: HTTPRequestMethod = .GET) {
        self.urlPath = urlPath
        self.pathValues = [pathValue: FlickrPath.None]
        self.method = httpMethod
    }
    
    init(urlPath: FlickrPath, nextValuesForPath path: [String: FlickrPath], httpMethod: HTTPRequestMethod = .GET) {
        self.urlPath = urlPath
        self.pathValues = path
        self.method = httpMethod
    }
    
    func url() -> URL {
        
        var url = Constant.Flickr.apiBaseURL + urlPath.rawValue
        
        if let values = pathValues, values.count > 0 {
            
            var urlVars = [String]()
            
            for (key, value) in values {
                
                /* Escape it */
                let escapedValue = key.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
                
                /* Append it */
                urlVars += [escapedValue! + (value.rawValue.isEmpty ? "" : "/\(value.rawValue)")]
            }
            
            url += "/" + urlVars.joined(separator: "/")
        }
        
        if let parameters = urlParameters, parameters.count > 0  {
            
            url += VirtualTouristHelper.escapedParameters(parameters)
        }
        
        return URL(string: url)!
    }
    
    func httpHeaderFields() -> [HeaderFieldForHTTP] {
        
        return [];
    }
    
    func httpBody() -> NSDictionary? {
        
        return json
    }
    
    func httpMethod() -> HTTPRequestMethod {
        
        return method
    }
    
    func newDataAfterRequest(_ data: Data) -> Data {
        
        return data
    }
}
