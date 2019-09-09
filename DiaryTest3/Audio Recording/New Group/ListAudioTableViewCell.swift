
import UIKit

class ListAudioTableViewCell: UITableViewCell {

    @IBOutlet weak var fileLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(filename: String) {
        self.fileLabel.text = filename
    }
}
