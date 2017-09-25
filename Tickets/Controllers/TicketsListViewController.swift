//
//  ViewController.swift
//  Tickets
//
//  Created by Hana  Demas on 9/23/17.
//  Copyright © 2017 ___HANADEMAS___. All rights reserved.
//

import UIKit

class TicketsListViewController: UIViewController {
    
    //MARK: Properties
    var apiDelegate: ZendeskApiClient?
    fileprivate var tickets = [Ticket]()
    fileprivate let cellId = "cell"
    //IBOutlets
    @IBOutlet var ticketsTableView: UITableView!
    
    //MARK: Viewcontroller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor =  UIColor.zendeskBlue()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        ticketsTableView.dataSource = self
        ticketsTableView.delegate = self
        ticketsTableView.separatorColor = UIColor.zendeskBlue()
        
        updateTableViewWithTickets()
    }
    
    //MARK: Custom fucntions
    func updateTableViewWithTickets() {
        if let ad = apiDelegate {
            ad.fetchZendeskTickets(completion: { (result) in
                switch result {
                case let .Success(tickets):
                    DispatchQueue.main.async {
                        self.tickets = tickets
                        self.ticketsTableView.reloadData()
                    }
                case let .Failure(error):
                    DispatchQueue.main.async {
                        if let error = error {
                            self.displayAlertWith(title: "Error", message: error.localizedDescription)
                        }
                    }
                }
            })}
    }
}

//MARK: viewcontroller extension for implementing datasource and delegates of uitableview
extension TicketsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func registerCellsForTableView(tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TicketsTableViewCell
        cell.setupTicketCell(ticket: tickets[indexPath.row])
        
        return cell
    }
}



