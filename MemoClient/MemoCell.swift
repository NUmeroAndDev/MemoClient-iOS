
import UIKit

class MemoCell: UITableViewCell {
    
    @IBOutlet weak var memoTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setMemo(memo: Memo) {
        memoTitleLabel.text = memo.value
    }

}
