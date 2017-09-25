//
//  TicketsTableViewCell.swift
//  Tickets
//
//  Created by Hana  Demas on 9/25/17.
//  Copyright © 2017 ___HANADEMAS___. All rights reserved.
//

import UIKit

class TicketsTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet var subjectLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var ticketNumberLabel: UILabel!
    @IBOutlet var ticketStatusLabel: UILabel!
    
    //MARK: ovveriden methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: Custom Functions
    
    //function to setup cell from a ticket object
    func setupTicketCell(ticket: Ticket?) {
        
        //style labels
        subjectLabel.font = Font.regular12
        descriptionLabel.font = Font.regular12
        ticketNumberLabel.font = Font.regular12
        ticketStatusLabel.font = Font.regular12
        
        if let ticket = ticket {
            subjectLabel.text = ticket.subject
            descriptionLabel.text = ticket.description
            ticketNumberLabel.text = "\(ticket.ticketNumber ?? 0)"
            ticketStatusLabel.text = ticket.status
        }
    }
}
