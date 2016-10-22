//
//  PopUp.swift
//  OraCodeChallenge
//
//  Created by Jonathan Jones on 10/22/16.
//  Copyright © 2016 Jon Jones. All rights reserved.
//

import UIKit

protocol PopUpDelegate {
    func popUpStringReceived(text: String)
}

class PopUp: UIView {
    
    var titleLabel: UILabel?
    var inputTextField: UITextField?
    var destinationFrame: CGRect?
    var parentViewController: UIViewController?
    var okButton: UIButton?
    var bgView: UIView?
    var delegate: PopUpDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(sourceFrame: CGRect, destFrame: CGRect, superViewController: UIViewController, title: String, textFieldPlaceholder: String) {
        super.init(frame: sourceFrame)
        parentViewController = superViewController
        layer.borderWidth = 1
        layer.borderColor = UIColor.orange.cgColor
        layer.cornerRadius = 10
        backgroundColor = .white
        
        destinationFrame = destFrame
        addBackgroundView()
        addLabel(title: title)
        addTextField(placeHolder: textFieldPlaceholder)
        addButton()
        animateContents()
    }
    
    func addBackgroundView() {
        bgView = UIView(frame: parentViewController!.view.frame)
        bgView!.alpha = 0.4
        bgView!.backgroundColor = .lightGray
        parentViewController?.view.addSubview(bgView!)
        parentViewController?.view.bringSubview(toFront: self)
    }
    
    func addLabel(title: String) {
        titleLabel = UILabel(frame: CGRect())
        titleLabel!.text = title
        titleLabel?.textAlignment = .center
        addSubview(titleLabel!)
    }
    
    func addTextField(placeHolder: String) {
        inputTextField = UITextField(frame: CGRect())
        inputTextField!.placeholder = placeHolder
        inputTextField!.textAlignment = .center
        addSubview(inputTextField!)
    }
    
    func addButton() {
        okButton = UIButton(frame: CGRect())
        okButton!.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        okButton!.backgroundColor = .orange
        okButton!.setTitleColor(.white, for: .normal)
        okButton!.setTitle("OK", for: .normal)
        okButton!.layer.cornerRadius = 17.5
        self.addSubview(okButton!)
    }
    
    func buttonTapped() {
        if inputTextField!.hasText {
            delegate?.popUpStringReceived(text: inputTextField!.text!)
        }
        bgView?.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    func animatedLabelFrame() -> CGRect {
        let origin = CGPoint(x: 5, y: 5)
        let size = CGSize(width: self.frame.width - 10, height: 35)
        return CGRect(origin: origin, size: size)
    }
    
    func animatedTextFieldFrame() -> CGRect {
        let origin = CGPoint(x: 5, y: 45)
        let size = CGSize(width: self.frame.width - 10, height: 60)
        return CGRect(origin: origin, size: size)
    }
    
    func animateButtonFrame() -> CGRect {
        let origin = CGPoint(x: 10, y: 110)
        let size = CGSize(width: self.frame.width - 20, height: 35)
        return CGRect(origin: origin, size: size)
        
    }
    
    func animateContents() {
        UIView.animate(withDuration: 0.2, animations: {
            self.frame = self.destinationFrame!
            self.titleLabel!.frame = self.animatedLabelFrame()
            self.inputTextField!.frame = self.animatedTextFieldFrame()
            self.okButton!.frame = self.animateButtonFrame()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
