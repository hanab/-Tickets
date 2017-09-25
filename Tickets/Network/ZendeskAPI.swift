//
//  ZendeskAPI.swift
//  Tickets
//
//  Created by Hana  Demas on 9/23/17.
//  Copyright © 2017 ___HANADEMAS___. All rights reserved.
//

import Foundation

enum Method: String {
    case AllTickets = "GET"
}
enum TicketResult {
    case Success([Ticket])
    case Failure(Error?)
}

enum ZendeskError: Error{
    case InvalidJSONData
    case NoData
}

struct ZendeskAPI {
    
    //MARK: Properties
    fileprivate static let subDomain = "mxtechtest"
    fileprivate static let id = 39551161
    fileprivate static let host = subDomain + ".zendesk.com"
    fileprivate static let path = "/api/v2/views/" + "\(id)" + "/tickets.json"
    
    //MARK: Functions
    
    //function to construct url object
    fileprivate static func zendeskURL(method: Method, parameters: [String: String]?) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    //Get get endpoint
    static func zendeskTicketsURL() -> URL {
        return zendeskURL(method: .AllTickets, parameters: nil)
    }
    
    //Function to construct Ticket object from json 
    private static func ticketFromJSONObject(json: [String : AnyObject]) -> Ticket? {
        guard let subject = json["subject"] as? String, let description = json["description"] as? String, let status = json["status"] as? String, let ticketNumber = json["id"] as? Int else {
            return nil
        }
        return Ticket(subject: subject, description: description, status: status, ticketNumber: ticketNumber)
    }
    
    //Get all tickets from json
    static func ticketsFromJSONData(data: Data?) -> TicketResult {
        do {
            guard let data = data  else {
                return .Failure(ZendeskError.NoData)
            }
            let jsonObject: AnyObject = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            guard let ticketsArray = jsonObject["tickets"] as? [[String: AnyObject]] else {
                return .Failure(ZendeskError.InvalidJSONData)
            }
            
            var finalTickets = [Ticket]()
            
            for ticketJSON in ticketsArray {
                if let ticket = ticketFromJSONObject(json: ticketJSON) {
                    finalTickets.append(ticket)
                }
            }
            
            if finalTickets.isEmpty && !ticketsArray.isEmpty {
                return .Failure(ZendeskError.InvalidJSONData)
            }
            return .Success(finalTickets)
        }
        catch let error {
            return .Failure(error)
        }
    }
}

