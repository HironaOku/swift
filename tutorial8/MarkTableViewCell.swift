//
//  MarkTableViewCell.swift
//  tutorial8
//
//  Created by Hirona Oku on 2021/05/20.
//

import UIKit
protocol InputTextTableCellDelegate {
    func textFieldDidEndEditing(cell: MarkTableViewCell, value: NSString) -> ()
}
class MarkTableViewCell: UITableViewCell, UITextFieldDelegate {
    var delegate: InputTextTableCellDelegate! = nil
    @IBOutlet var StudentIDLabel: UILabel!
    @IBOutlet var GradeLabel: UILabel!
    @IBOutlet var FirstNameLabel: UILabel!
    @IBOutlet var LastNameLabel: UILabel!
        
    @IBOutlet var button: UIButton!
    @IBOutlet var Score: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.Score.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal func textFieldShouldReturn(_ Score: UITextField) -> Bool {
        Score.resignFirstResponder()
        return true
    }
    internal func textFieldDidEndEditing(_ Score: UITextField,
                                         reason: UITextField.DidEndEditingReason){
        self.delegate.textFieldDidEndEditing(cell: self, value: Score.text! as NSString)
        print(Score.text!)
    }
}
