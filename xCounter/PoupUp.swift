import UIKit
import RealmSwift


class PoupUpScoredView: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var viewOnBack: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        viewOnBack.layer.cornerRadius = 10
        viewOnBack.layer.masksToBounds = true
	}
    
    @IBAction func closePopUpView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
	
}

extension PoupUpScoredView: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return DBManager.shared.getDataFromDB().count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
		
		let item = DBManager.shared.getDataFromDB() [indexPath.row] as Counter

		cell.nameLabel.text = item.name
		cell.countLabel.text = String(describing: item.count)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let indexPath = tableView.indexPathForSelectedRow
		let currentCell = tableView.cellForRow(at: indexPath!) as! CustomCell
		
		if let presenter = presentingViewController as? PushButtonVC {
			presenter.counterLabel.text = currentCell.countLabel.text
			presenter.counterShadowLabel.text = currentCell.countLabel.text
			presenter.someValue = Int(currentCell.countLabel.text!)!
		}
		dismiss(animated: true, completion: nil)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let index = indexPath.row
			let item = DBManager.shared.getDataFromDB()[index] as Counter
			DBManager.shared.deleteFromDb(object: item)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
}
