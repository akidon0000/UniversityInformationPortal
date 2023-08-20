//
//  HelpmessageAgreeViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/20.
//

import UIKit

class HelpmessageAgreeView: UIView {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var closedButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
