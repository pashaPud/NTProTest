import UIKit

class DealCell: UITableViewCell {
  static let reuseIidentifier = "DealCell"
  
  @IBOutlet weak var instrumentNameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var sideLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        instrumentNameLabel.text = nil
        priceLabel.text = nil
        amountLabel.text = nil
        sideLabel.text = nil
    }
    
    func setDealCell(with deal: Deal) {
        instrumentNameLabel.text = "\(deal.instrumentName)"
        priceLabel.text = String(format: "%.2f", deal.price)
        priceLabel.textColor = deal.side == .sell ? .red : .green
        amountLabel.text = String(format: "%.0f",deal.amount)
        sideLabel.text = "\(deal.side)"
        sideLabel.textColor = deal.side == .sell ? .red : .green
    }
}
