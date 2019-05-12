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
		animationScaleEffect(view: xLabel, animationTime: 0.07)
		animationScaleEffect(view: xLabelShadow, animationTime: 0.07)
		
	}
	
	@IBAction func addResult(_ sender: Any) {
		
		let alertController = UIAlertController(title: "Call counter", message: "Save the result of your calculation", preferredStyle: .alert)
		
		let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
			alert -> Void in
			
			let firstTextField = alertController.textFields![0] as UITextField
			
			guard let text = firstTextField.text else { return }
			guard let count = self.counterLabel.text else { return }
			let counter = Counter()
			counter.name = text
			counter.count = Int(count)!
			DBManager.shared.addData(object: counter)
			self.presentAlert(withTitle: "Save", message: "Value \(text) has been saved or update")
		})
		
		saveAction.isEnabled = false
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
		
		alertController.addTextField { (textField) in
			
			textField.placeholder = "Enter name"
			NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
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
		animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
		animation.duration = 0.6
		animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
		layer.add(animation, forKey: "shake")
	}
}

extension UIViewController {
	
	func presentAlert(withTitle title: String, message : String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let OKAction = UIAlertAction(title: "OK", style: .default) { action in
		}
		alertController.addAction(OKAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
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
