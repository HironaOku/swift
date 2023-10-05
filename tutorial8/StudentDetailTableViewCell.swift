//
//  StudentDetailTableViewCell.swift
//
//  Created by Hirona Oku on 2021/05/23.
//

import UIKit

class StudentDetailTableViewCell: UITableViewCell {
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var markTypeLabel: UILabel!
    @IBOutlet var gradeLabel: UILabel!
    @IBOutlet var markpercentageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
