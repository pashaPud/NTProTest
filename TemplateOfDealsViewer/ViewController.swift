import UIKit

class ViewController: UIViewController {
    let queue = DispatchQueue(label: "DealsMakeQueue")
    private let server = Server()
    private var model: [Deal] = []
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let filtersButton = UIButton(type: .custom)
    private var currentFilterState: Filters = .dateDefault
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Deals"
        
        tableView.register(UINib(nibName: DealCell.reuseIidentifier, bundle: nil), forCellReuseIdentifier: DealCell.reuseIidentifier)
        tableView.register(UINib(nibName: HeaderCell.reuseIidentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: HeaderCell.reuseIidentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        setUpNavbarButton()
        server.subscribeToDeals { [weak self] deals in
            self?.queue.async {
                self?.model.append(contentsOf: deals)
                self?.sortTable(with: self?.currentFilterState ?? .dateDefault ) {
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.activityIndicator.isHidden = true
                        self?.tableView.isHidden = false
                    }
                }
            }
        }
    }
    
    private func setUpNavbarButton() {
        filtersButton.translatesAutoresizingMaskIntoConstraints = false
        filtersButton.setBackgroundImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        filtersButton.addTarget(self, action: #selector(self.setFilterState(_:)), for: .touchUpInside)
        let navBarButton = UIBarButtonItem(customView: filtersButton)
        self.navigationItem.rightBarButtonItem = navBarButton
    }
    
    @objc func setFilterState(_ sender: UIButton) {
        
        let filtersVC = FiltersViewController()
        filtersVC.completion = { [weak self] filter in
            self?.currentFilterState = filter
            DispatchQueue.main.async {
                self?.activityIndicator.isHidden = false
                self?.tableView.isHidden = true
            }
        }
        self.present(filtersVC, animated: true)
    }
    
    private func sortTable(with filter: Filters, completion: @escaping ()->()) {
        switch filter {
        case .instrASC:
            self.model = self.model.sorted() {
                $0.instrumentName < $1.instrumentName
            }
        case .instrDESC:
            self.model = self.model.sorted() {
                $0.instrumentName > $1.instrumentName
            }
        case .priceASC:
            self.model = self.model.sorted() {
                $0.price < $1.price
            }
        case .priceDESC:
            self.model = self.model.sorted() {
                $0.price > $1.price
            }
        case .amountASC:
            self.model = self.model.sorted() {
                $0.amount < $1.amount
            }
        case .amountDESC:
            self.model = self.model.sorted() {
                $0.amount > $1.amount
            }
        case .buyFirst:
            self.model = self.model.sorted() {
                if $0.side == .buy && $1.side == .sell {
                    return true
                } else {
                    return false
                }
            }
        case .sellFirst:
            self.model = self.model.sorted() {
                if $0.side == .buy && $1.side == .sell {
                    return false
                } else {
                    return true
                }
            }
        case .dateDefault:
            self.model = self.model.sorted() {
                $0.dateModifier < $1.dateModifier
            }
        }
        completion()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DealCell.reuseIidentifier, for: indexPath) as! DealCell
        cell.setDealCell(with: self.model[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderCell.reuseIidentifier) as! HeaderCell
        return cell
    }
}

