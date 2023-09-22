//
//  MainController1Cel.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/18.
//

import UIKit
class MainController1Cell: UITableViewCell{
    
    @IBOutlet weak var labelView: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        //和viewdidload一个性质的初始化
        contentView.backgroundColor = UIColor.clear
    }
}
