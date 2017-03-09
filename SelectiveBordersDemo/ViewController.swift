//
//  ViewController.swift
//  SelectiveBordersDemo
//
//  Created by Ismail GULEK on 27/02/2017.
//  Copyright © 2017 Ismail Gulek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var customView: SelectiveBordersView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		customView.selectiveBorderWidth = 3.0
		customView.selectiveBorderColor = UIColor.red
		customView.borders = .all
		
		/*	sample usage:
		customView.borders = .all
		customView.borders = [.left, .top]
		*/
	}
	
	@IBAction func switchValueChanged(_ sender: UISwitch) {
		let tag = sender.tag
		let isOn = sender.isOn
		
		var member: SelectiveBorderType
		
		if tag == 1 {
			member = .top
		} else if tag == 2 {
			member = .left
		} else if tag == 3 {
			member = .bottom
		} else {
			member = .right
		}
		
		if isOn {
			customView.borders.insert(member)
		} else {
			customView.borders.remove(member)
		}
	}
	
	@IBAction func sliderValueChanged(_ slider: UISlider) {
		customView.selectiveBorderWidth = CGFloat(slider.value)
	}

}
