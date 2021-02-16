//
//  ItemSelectorViewController.swift
//  core_data_homework
//
//  Created by Андрей Груненков on 28.02.2021.
//

import UIKit

final class ItemSelectorViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var items: [String] = []
    var itemSelected: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    @IBAction func tapOkButton(_ sender: Any) {
        itemSelected?(pickerView.selectedRow(inComponent: 0))
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ItemSelectorViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
}
