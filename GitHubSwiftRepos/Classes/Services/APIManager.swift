//
//  APIManager.swift
//  GitHubSwiftRepos
//
//  Created by Bruno Fonseca de Almeida on 20/11/19.
//  Copyright © 2019 Bruno Fonseca de Almeida. All rights reserved.
//

import UIKit
import SwiftyJSON

class APIManager: NSObject {
  let baseURL = "https://api.github.com"
  static let sharedInstance = APIManager()
  static let Endpoint = "/search/repositories?q=language:swift&sort=stars&page="
      
  func getSwiftRepositories(page: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
    let url : String = baseURL + APIManager.Endpoint + "\(page)"
    let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
    request.httpMethod = "GET"

    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
        if(error != nil){
            onFailure(error!)
        } else{
          do {
            let result = try JSON(data: data!)
            onSuccess(result)
          } catch {
            print("Erro ao parsear JSON")
            onFailure(error)
          }
        }
    })

    task.resume()
  }
}
