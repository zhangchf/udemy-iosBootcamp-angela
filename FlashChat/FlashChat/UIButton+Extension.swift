//
//  UIButton+Extension.swift
//  FlashChat
//
//  Created by Chaofan Zhang on 27/03/2018.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import UIKit

extension UIButton {
    
    open override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
}
