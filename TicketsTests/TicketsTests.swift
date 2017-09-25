//
//  TicketsTests.swift
//  TicketsTests
//
//  Created by Hana  Demas on 9/23/17.
//  Copyright © 2017 ___HANADEMAS___. All rights reserved.
//

import XCTest
@testable import Tickets

class TicketsTests: XCTestCase {
    
    //MARK: Properties
    fileprivate let apiDelegate = ZendeskApiClient()
    
    //MARK: XCTest overriden methods
    override func setUp() {
        super.setUp()
    }
    
    //MARK: Test functions
    func testNetworkRespose() {
        let testExpectation =  expectation(description: "Zendesk tickets info expectation")
        
        apiDelegate.fetchZendeskTickets(completion: { (result) in
            switch result {
            case let .Success(tickets):
                XCTAssert(tickets.count == 45, "more or less tickets than expected \(tickets.count)")
                XCTAssertEqual(tickets[0].subject, "Ticket : 99", "The ticket subject should be as expected")
                XCTAssertEqual(tickets[0].status, "new", "The ticket status should be as expected")
                XCTAssertEqual(tickets[0].description, "This is a test ticket", "The ticket description should be as expected")
                XCTAssertEqual(tickets[0].ticketNumber, 103, "The ticket number should be as expected")
                testExpectation.fulfill()
            case .Failure:
                print("error")
            }
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    //test object initialization
    func testDataInitializationTest() {
        var ticket:Ticket = Ticket(subject: "", description: "", status: "", ticketNumber: 1)
        ticket.description = "test ticket"
        ticket.status = "open"
        ticket.ticketNumber = 67
        ticket.subject = "Ticket 11"
        XCTAssertEqual(ticket.subject, "Ticket 11", "The ticket subject should be as expected")
        XCTAssertEqual(ticket.status, "open", "The ticket status should be as expected")
        XCTAssertEqual(ticket.description, "test ticket", "The ticket description should be as expected")
        XCTAssertEqual(ticket.ticketNumber, 67, "The ticket number should be as expected")
    }
}

