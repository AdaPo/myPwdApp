//
//  PasswordCell.swift
//  myPwdApp
//
//  Created by Adam Poustka on 2021-03-28.
//

import UIKit
import CryptoKit

class PasswordCell: UITableViewCell {

    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var passwordTextLabel: UILabel!
    @IBOutlet weak var showSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func showSwitchValueChanged(_ sender: UISwitch) {
        passwordTextLabel.isHidden = !passwordTextLabel.isHidden
    }
    
}
