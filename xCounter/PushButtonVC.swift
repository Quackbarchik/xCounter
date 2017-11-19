//
//  PushButtonVC.swift
//  xCounter
//
//  Created by Zakhar Rudenko on 05.10.2017.
//  Copyright © 2017 Zakhar Rudenko. All rights reserved.
//

import UIKit
import CoreGraphics
import CoreData
import QuartzCore


class PushButtonVC: UIViewController, UIAlertViewDelegate {

    var massiv = [String]()

    @IBOutlet weak var counterShadowLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var xButton: MyButton!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var xLabelShadow: UILabel!
    @IBOutlet weak var infoButton: MyButton!
    
    var someValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func action(_ sender: Any) {
        someValue += 1
        counterLabel.text = "\(someValue)"
        counterShadowLabel.text = "\(someValue)"
        animationScaleEffect(view: xButton, animationTime: 0.07)
    }
    
    func request(){
        
        massiv = []
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let results = try context.fetch(Counter.fetchRequest())
            let get = results as! [Counter]
            
            for item in get {
                massiv.append(item.name ?? "----")
            }
            
        } catch {}
    }
    
    func saveData(username: String, count: String){
        
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let user = Counter(context: context)
        
        user.name = username
        user.count = count
        
        appDelegate.saveContext()
    }
    
    @IBAction func addResult(_ sender: Any) {
            self.generationAlert()
        }
    
    func generationAlert() {
        
        let alertController = UIAlertController(title: "Назовите счётчик", message: "Сохраните результат вашего счисления", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            
            if let text = firstTextField.text{
                if !self.massiv.isEmpty{
                    if self.massiv.contains(text) {
                        let alertVC = UIAlertController(title: "Ошибка", message: "Значение \(text) уже есть", preferredStyle: .alert)
                        let cancelAct = UIAlertAction(title: "Изменить", style: .cancel, handler: {
                            (action : UIAlertAction!) -> Void in
                        })
                        alertVC.addAction(cancelAct)
                        alertController.dismiss(animated: true, completion: nil)
                        self.present(alertVC, animated: true, completion: nil)
                        
                    } else {
                        self.saveData(username: text, count: self.counterLabel.text!)
                        self.request()
                        let alertVC1 = UIAlertController(title: "Сохранено!", message: "Значение \(text) было сохранено", preferredStyle: .alert)
                        let cancelAct = UIAlertAction(title: "Понятно", style: .default, handler: {
                            (action : UIAlertAction!) -> Void in
                        })
                        alertVC1.addAction(cancelAct)
                        self.present(alertVC1, animated: true, completion: nil)
                    }
                } else{
                    self.saveData(username: text, count: self.counterLabel.text!)
                    self.request()
                    
                    let alertVC2 = UIAlertController(title: "Сохранено!", message: "Значение \(text) было сохранено", preferredStyle: .alert)
                    let cancelAct = UIAlertAction(title: "Понятно", style: .default, handler: {
                        (action : UIAlertAction!) -> Void in
                    })
                    alertVC2.addAction(cancelAct)
                    self.present(alertVC2, animated: true, completion: nil)
                }
            }
        })
        
        saveAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField) in
            
            textField.placeholder = "Введите имя"
            NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: textField, queue: OperationQueue.main, using:
                {_ in
                    
                    let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    saveAction.isEnabled = textIsNotEmpty
            })
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Анимирование любого элемента наследованного от UIView
    func animationScaleEffect(view:UIView,animationTime:Float){
        UIView.animate(withDuration: TimeInterval(animationTime), animations: {
            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        },completion:{completion in
            UIView.animate(withDuration: TimeInterval(animationTime), animations: { () -> Void in
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
    }
    
    
}

@IBDesignable class MyButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var highlightedBackgroundColor :UIColor?
    @IBInspectable var nonHighlightedBackgroundColor :UIColor?
    override var isHighlighted :Bool {
        get {
            return super.isHighlighted
        }
        set {
            if newValue {
                self.backgroundColor = highlightedBackgroundColor
            }
            else {
                self.backgroundColor = nonHighlightedBackgroundColor
            }
            super.isHighlighted = newValue
        }
    }
}
    
extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

