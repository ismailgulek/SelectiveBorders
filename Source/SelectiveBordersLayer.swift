//
//  SelectiveBordersLayer.swift
//
//  Created by Ismail GULEK on 27/02/2017.
//  Copyright © 2017 Ismail Gulek. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

//	Border types
struct SelectiveBorderType: OptionSet {
	
	let rawValue: Int
	
	static var top = SelectiveBorderType(rawValue: 1 << 0)
	static var left = SelectiveBorderType(rawValue: 1 << 1)
	static var bottom = SelectiveBorderType(rawValue: 1 << 2)
	static var right = SelectiveBorderType(rawValue: 1 << 3)
	
	static var all = SelectiveBorderType(rawValue: 16 - 1)
}

//	UIView subclass
class SelectiveBordersView: UIView, SelectiveBordersProtocol {
	
	//  You must add below override code to your subclass in order to use selective borders
	override class var layerClass: AnyClass {
		get {
			return SelectiveBordersLayer.self
		}
	}
	
}

//	CALayer subclass
class SelectiveBordersLayer: CALayer {
	
	var _topBorder: CALayer?
	var _leftBorder: CALayer?
	var _bottomBorder: CALayer?
	var _rightBorder: CALayer?
	
	var selectiveBorderColor: UIColor = UIColor.lightGray {
		didSet {
			_topBorder?.backgroundColor = selectiveBorderColor.cgColor
			_leftBorder?.backgroundColor = selectiveBorderColor.cgColor
			_bottomBorder?.backgroundColor = selectiveBorderColor.cgColor
			_rightBorder?.backgroundColor = selectiveBorderColor.cgColor
		}
	}
	var selectiveBorderWidth: CGFloat = 1.0 {
		didSet {
			self.removeAllBorderLayers()
			self.arrangeBorderLayers()
		}
	}
	
	var borders: SelectiveBorderType = [] {
		didSet {
			self.arrangeBorderLayers()
		}
	}
	
	fileprivate func removeAllBorderLayers() {
		_topBorder?.removeFromSuperlayer()
		_topBorder = nil
		_leftBorder?.removeFromSuperlayer()
		_leftBorder = nil
		_bottomBorder?.removeFromSuperlayer()
		_bottomBorder = nil
		_rightBorder?.removeFromSuperlayer()
		_rightBorder = nil
	}
	
	fileprivate func arrangeBorderLayers() {
		//	implemented like this to avoid blinking
		//	please do NOT change
		var newLayerAdded = false
		
		//	top
		if borders.contains(.top) {
			if _topBorder == nil {
				_topBorder = self.createNewBorderLayer()
				newLayerAdded = true
			}
		} else {
			_topBorder?.removeFromSuperlayer()
			_topBorder = nil
		}
		
		//	left
		if borders.contains(.left) {
			if _leftBorder == nil {
				_leftBorder = self.createNewBorderLayer()
				newLayerAdded = true
			}
		} else {
			_leftBorder?.removeFromSuperlayer()
			_leftBorder = nil
		}
		
		//	bottom
		if borders.contains(.bottom) {
			if _bottomBorder == nil {
				_bottomBorder = self.createNewBorderLayer()
				newLayerAdded = true
			}
		} else {
			_bottomBorder?.removeFromSuperlayer()
			_bottomBorder = nil
		}
		
		//	right
		if borders.contains(.right) {
			if _rightBorder == nil {
				_rightBorder = self.createNewBorderLayer()
				newLayerAdded = true
			}
		} else {
			_rightBorder?.removeFromSuperlayer()
			_rightBorder = nil
		}
		
		//	update layout if new layer added
		if newLayerAdded {
			self.setNeedsLayout()
		}
	}
	
	fileprivate func createNewBorderLayer() -> CALayer {
		let layer = CALayer()
		layer.backgroundColor = self.selectiveBorderColor.cgColor
		self.addSublayer(layer)
		return layer
	}
	
	override func layoutSublayers() {
		super.layoutSublayers()
		
		_topBorder?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.selectiveBorderWidth)
		_leftBorder?.frame = CGRect(x: 0, y: 0, width: self.selectiveBorderWidth, height: self.frame.height)
		_bottomBorder?.frame = CGRect(x: 0, y: self.frame.height - self.selectiveBorderWidth, width: self.frame.width, height: self.selectiveBorderWidth)
		_rightBorder?.frame = CGRect(x: self.frame.width - self.selectiveBorderWidth, y: 0, width: self.selectiveBorderWidth, height: self.frame.height)
		
	}
	
}

extension SelectiveBordersProtocol where Self: UIView {
    
    var layer: SelectiveBordersLayer {
        get {
            return layer as! SelectiveBordersLayer
        }
    }
    
    var selectiveBorderWidth: CGFloat {
        get {
            return self.layer.selectiveBorderWidth
        }
        set {
            self.layer.selectiveBorderWidth = newValue
        }
    }
    
    var selectiveBorderColor: UIColor {
        get {
            return self.layer.selectiveBorderColor
        }
        set {
            self.layer.selectiveBorderColor = newValue
        }
    }
    
    var borders: SelectiveBorderType {
        get {
            return self.layer.borders
        }
        set {
            self.layer.borders = newValue
        }
    }
    
}

protocol SelectiveBordersProtocol {
    
    var layer: SelectiveBordersLayer { get }
    var selectiveBorderWidth: CGFloat { get set }
    var selectiveBorderColor: UIColor { get set }
    var borders: SelectiveBorderType { get set }
    
}
