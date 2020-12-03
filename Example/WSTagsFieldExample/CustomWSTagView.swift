//
//  CustomWSTagView.swift
//  WSTagsFieldExample
//
//  Created by Nuno Grilo on 26/05/2020.
//  Copyright © 2020 Whitesmith. All rights reserved.
//

import UIKit
import WSTagsField

class CustomWSTagView: WSTagView {
//    override var tintColor: UIColor! {
//        didSet {
//            guard tintColor != oldValue else { return }
//            tintColor = .black
//            backgroundColor = .yellow
//        }
//    }
    
    private var label: UILabel { (subviews.compactMap { $0 as? UILabel }).first ?? UILabel() }
    private var closeButton: UIButton = UIButton(type: .custom)
    
    // MARK - Initializatrion
    
    required init(tag: WSTag) {
        super.init(tag: tag)
        
        // process tag
        self.isReadonly = false
        
        // close button
        closeButton.frame = CGRect(x: label.frame.maxX + labelCloseSeparatorSpace, y: layoutMargins.top, width: closeButtonSize.width, height: closeButtonSize.height)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.setImage(UIImage(named: "cmtsRecipientRemove"), for: .normal)
        closeButton.addTarget(self, action: #selector(handleCloseTap), for: .touchUpInside)
        addSubview(closeButton)
        
        setNeedsLayout()
    }
    
    
    // MARK: - 'x' Close button
    
    open var showCloseButton: Bool = true {
        didSet { updateContent() }
    }
    
    private var isShowCloseButtonVisible: Bool { !isReadonly && showCloseButton }
    
    
    // MARK: - Readonly
    
    open var isReadonly: Bool = false {
        didSet { updateContent() }
    }
    
    open override func deleteBackward() {
        guard !isReadonly else { return }
        super.deleteBackward()
    }
    
    // MARK: - Appearance
    
    open var tagColor: UIColor? {
        didSet { updateContent() }
    }

    open var readonlyColor: UIColor? {
        didSet { updateContent() }
    }

    open var readonlyTextColor: UIColor? {
        didSet { updateContent() }
    }
    
    // Remove animation & disable selection if read-only
    open override var selected: Bool {
        didSet {
            if !isReadonly && selected && !isFirstResponder {
                _ = becomeFirstResponder()
            } else if !selected && isFirstResponder {
                _ = resignFirstResponder()
            }
            updateContent()
        }
    }
    
    
    // MARK: - Content
    
    /// Update view's contents.
    /// PS: We are updating content ourselves here, since `updateContent(animated:)` is protected.
    open override func updateColors() {
        backgroundColor = isReadonly ? readonlyColor : (selected ? selectedColor : tagColor)
        label.textColor = isReadonly ? readonlyTextColor : (selected ? selectedTextColor : textColor)
    }
    
    private func updateButton() {
        closeButton.isHidden = !isShowCloseButtonVisible
    }
    
    open override func updateContent(animated: Bool = false) {
        updateColors()
        updateButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Actions
    
    @objc private func handleCloseTap(_ button: UIButton) {
        deleteBackward()
    }
    
    
    // MARK: - Size measurements
    
    let closeButtonSize: CGSize = .init(width: 14, height: 14)
    
    let labelCloseSeparatorSpace: CGFloat = 0

    open override var intrinsicContentSize: CGSize {
        guard isShowCloseButtonVisible else { return super.intrinsicContentSize }
        
        let labelIntrinsicSize = label.intrinsicContentSize
        return CGSize(width: layoutMargins.left + labelIntrinsicSize.width + labelCloseSeparatorSpace + closeButtonSize.width + layoutMargins.right,
                      height: labelIntrinsicSize.height + layoutMargins.top + layoutMargins.bottom)
        
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard isShowCloseButtonVisible else { return super.sizeThatFits(size) }
        
        var fittingSize = super.sizeThatFits(size)
        fittingSize.width += labelCloseSeparatorSpace + closeButtonSize.width
        return fittingSize
    }

    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard isShowCloseButtonVisible else { return }
        
        var labelFrame = bounds.inset(by: layoutMargins)
        labelFrame.size.width = labelFrame.width - labelCloseSeparatorSpace - closeButton.bounds.width
        label.frame = labelFrame
        closeButton.frame = CGRect(x: label.frame.maxX + labelCloseSeparatorSpace + 4, y: layoutMargins.top, width: closeButton.bounds.width, height: closeButton.bounds.height)
        
        if frame.width == 0 || frame.height == 0 {
            frame.size = self.intrinsicContentSize
        }
    }
    
}
