//
//  ZendeskApiClient.swift
//  Tickets
//
//  Created by Hana  Demas on 9/23/17.
//  Copyright © 2017 ___HANADEMAS___. All rights reserved.
//

import Foundation

class ZendeskApiClient {
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        let userEmail = "acooke+techtest@zendesk.com"
        let userPasswordString = "mobile"
        let userPasswordData = "\(userEmail):\(userPasswordString)".data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        let authString = "Basic \(base64EncodedCredential ?? "")"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        return URLSession(configuration: config)
    }()
    
    private func fetchTickets(url: URL, completion: @escaping (_ Tickets: TicketResult) -> ()) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler:  { (data, response, error) -> Void in
            let results = self.processTicketsRequest(data: data, error: error)
            completion(results)
        })
        task.resume()
    }
    func processTicketsRequest(data: Data?, error: Error?) -> TicketResult {
        guard data != nil else {
            return .Failure(error)
        }
        return ZendeskAPI.ticketsFromJSONData(data: data)
    }
    
    func fetchZendeskTickets(completion: @escaping (_ tickets: TicketResult) -> ()) {
        let url = ZendeskAPI.zendeskTicketsURL()
        fetchTickets(url: url, completion: completion)
    }
}
