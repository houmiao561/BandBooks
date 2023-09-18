//
//  MainCell.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/16.
//

import UIKit
class MainCell: UITableViewCell{
    @IBOutlet weak var MainCellImage: UIImageView!
    @IBOutlet weak var MainCellLabel: UILabel!
    var doneImage: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //和viewdidload一个性质的初始化
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            if doneImage == false{
                MainCellImage.image = UIImage(named: "Yummy")
                doneImage = true
            }else{
                MainCellImage.image = nil
                doneImage = false
            }
        }
        
    }

}
