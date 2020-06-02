//
//  CustomWSTagsField.swift
//  WSTagsFieldExample
//
//  Created by Nuno Grilo on 26/05/2020.
//  Copyright © 2020 Whitesmith. All rights reserved.
//

import UIKit
import WSTagsField

class CustomWSTagsField: WSTagsField {
    
    override var tagViewClass: WSTagView.Type { CustomWSTagView.self }
    
    // Background color for tag view in normal.
    override var tagColor: UIColor? {
        didSet {
            recipientViews.forEach { $0.tagColor = self.tagColor }
        }
    }
    
    open var recipientViews: [CustomWSTagView] { (subviews.compactMap { $0 as? CustomWSTagView }) }
    
}
