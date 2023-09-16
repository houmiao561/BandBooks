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

//var doneImage: Bool = false
//let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell
//if doneImage == false{
//    doneImage = true
//    cell.MainCellImage.image = UIImage(named: "Yummy")
//}else{
//    doneImage = false
//    cell.MainCellImage.image = nil
//}


//if selected {
//    if let mainCellImage = self.MainCellImage {
//        mainCellImage.image = UIImage(named: "Yummy")
//        //tableView.deselectRow(at: indexPath, animated: true)
//    } else {
//        print("111111")
//        // 如果 MainCellImage 为 nil，执行适当的错误处理
//    }
//    // 单元格被选中
//    // 在这里执行你的自定义操作，例如更改背景颜色、添加标记等
//} else {
//
//    // 单元格取消选中
//    // 在这里执行其他自定义操作
//}
