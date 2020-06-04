//
//  RegularTaskButton.swift
//  ProjectFND
//
//  Created by Elly Richardson on 6/2/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class RegularTaskButton: TransformingButton {
    let regularTaskImage = UIImage(named: "FilledRegularTask")! as UIImage
    let notRegularTaskImage = UIImage(named: "EmptyRegularTask")! as UIImage
    
    private var toDoRowIndex: Int = Int()
    
    private var isPressed: Bool = false {
        didSet{
            if getPressedStatus() == true {
                print("pressed status")
                print(getPressedStatus())
                self.setImage(regularTaskImage, for: UIControl.State.normal)
            } else {
                self.setImage(notRegularTaskImage, for: UIControl.State.normal)
            }
        }
    }
    
    //private var isChecked: Bool = Bool()
    
    override func getPressedStatus() -> Bool {
        return self.isPressed
    }
    
    
    override func setPressedStatus(isPressed: Bool) {
        self.isPressed = isPressed
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonPressed(sender:)), for: UIControl.Event.touchUpInside)
        self.setPressedStatus(isPressed: false)
        self.toDoRowIndex = Int()
    }
    
    func setNotifyingRowIndex(toDoRowIndex: Int) {
        self.toDoRowIndex = toDoRowIndex
    }
    
    func getNotifyingRowIndex() -> Int {
        return self.toDoRowIndex
    }
    
    override func buttonPressed(sender: UIButton) {
        if sender == self {
            self.setPressedStatus(isPressed: !self.getPressedStatus())
        }
    }
}
