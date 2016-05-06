//
//  PartyFormViewController.swift
//  Dictator
//
//  Created by Eran Kaufman on 5/5/16.
//  Copyright © 2016 Eran Kaufman. All rights reserved.
//

import UIKit
import Former


class PartyFormViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let nameRow = TextFieldRowFormer<FormTextFieldCell>().configure{ row in
            row.placeholder = "Party Name"
            
        }
        
        let header = LabelViewFormer<FormLabelHeaderView>() { view in
            view.titleLabel.text = "Create Your Party"
        }
        
        let section = SectionFormer(rowFormer: nameRow)
            .set(headerViewFormer: header)
        former.append(sectionFormer: section)
        
        return
        let labelRow = LabelRowFormer<FormLabelCell>()
            .configure { row in
                row.text = "Label Cell"
            }.onSelected { row in
                // Do Something
        }
        let inlinePickerRow = InlinePickerRowFormer<FormInlinePickerCell, Int>() {
            $0.titleLabel.text = "Inline Picker Cell"
            }.configure { row in
                row.pickerItems = (1...5).map {
                    InlinePickerItem(title: "Option\($0)", value: Int($0))
                }
            }.onValueChanged { item in
                // Do Something
        }
    }

    override func didReceiveMemoryWarning() {
    }

}
