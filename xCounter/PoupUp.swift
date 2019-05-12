import UIKit
import CoreData


class PoupUpScoredView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var viewOnBack: UIView!
    
    var arrayOfNames = [String]()
    var arrayOfCounter = [String]()
    
    var valueToPass: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        viewOnBack.layer.cornerRadius = 10
        viewOnBack.layer.masksToBounds = true
        
        request()
    }
    
    @IBAction func closePopUpView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfNames.count
    }
    
    func request(){
        
        arrayOfNames = []
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let results = try context.fetch(Counter.fetchRequest())
            let get = results as! [Counter]
            
            for item in get {
                arrayOfNames.append(item.name ?? "Unnamed")
                arrayOfCounter.append(item.count ?? "0000")
            }
            //если вы читаете это, то займитесь уже делом
        } catch {}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        cell.nameLabel.text = arrayOfNames[indexPath.row]
        cell.countLabel.text = arrayOfCounter[indexPath.row]
        
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
}

