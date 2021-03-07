//
//  PlayerSearchViewController.swift
//  core_data_homework
//
//  Created by Андрей Груненков on 16.02.2021.
//

import UIKit

final class PlayerSearchViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var selectPositionButton: UIButton!
    @IBOutlet weak var selectTeamButton: UIButton!
    
    var searchClosure: (([NSPredicate]) -> Void)?
    var searchPredicates: [NSPredicate] = []
    
    var dataManager: CoreDataManager!
    var teams: [Club] = []
    var team: Club?
    var position: String?
    
    var ageOperator: String = ">="
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPickersData()
        self.addTarget()
    }
    
    @IBAction func selectPositionTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Common", bundle: Bundle.main)
        guard let itemSelectorViewController = storyboard.instantiateViewController(withIdentifier: String(describing: ItemSelectorViewController.self)) as? ItemSelectorViewController else {
            return
        }
        itemSelectorViewController.modalTransitionStyle = .crossDissolve
        itemSelectorViewController.modalPresentationStyle = .overFullScreen
        itemSelectorViewController.items = MockData.positions
        itemSelectorViewController.itemSelected = { [weak self] row in
            guard let _self = self else { return }
            _self.position = MockData.positions[row]
            UIView.performWithoutAnimation {
                _self.selectPositionButton.setTitle(MockData.positions[row], for: .normal)
            }
            itemSelectorViewController.dismiss(animated: true, completion: nil)
        }
        self.present(itemSelectorViewController, animated: true, completion: nil)
    }
    
    @IBAction func selectTeamTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Common", bundle: Bundle.main)
        guard let itemSelectorViewController = storyboard.instantiateViewController(withIdentifier: String(describing: ItemSelectorViewController.self)) as? ItemSelectorViewController else {
            return
        }
        itemSelectorViewController.modalTransitionStyle = .crossDissolve
        itemSelectorViewController.modalPresentationStyle = .overFullScreen
        itemSelectorViewController.items = teams.map { $0.name ?? "unknown" }
        itemSelectorViewController.itemSelected = { [weak self] row in
            guard let _self = self else { return }
            _self.team = _self.teams[row]
            UIView.performWithoutAnimation {
                _self.selectTeamButton.setTitle(_self.teams[row].name, for: .normal)
            }
            itemSelectorViewController.dismiss(animated: true, completion: nil)
        }
        self.present(itemSelectorViewController, animated: true, completion: nil)
    }
    
    @IBAction func startSearchTap(_ sender: Any) {
        if let fullname = nameField.text,
           !fullname.isEmpty {
            searchPredicates.append(NSPredicate(format: "fullname contains %@", fullname))
        }
        if let age = ageField.text,
           !age.isEmpty {
            let ageSearch = "age" + ageOperator + age
            searchPredicates.append(NSPredicate(format: ageSearch))
        }
        if let _team = self.team,
           let name = _team.name {
            searchPredicates.append(NSPredicate(format: "club.name = %@", name))
        }
        if let _position = self.position {
            searchPredicates.append(NSPredicate(format: "position like %@", _position))
        }
        self.applyAndClose()
    }
    
    @IBAction func resetTap(_ sender: Any) {
        self.applyAndClose()
    }
    
    @IBAction func operatorChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            self.ageOperator = "<="
        case 2:
            self.ageOperator = "="
        default:
            self.ageOperator = ">="
        }
    }
    
    
    private func applyAndClose() {
        self.searchClosure?(searchPredicates)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTapSpace() {
        view.endEditing(true)
    }
    
}

private extension PlayerSearchViewController {
    
    func setupPickersData() {
        self.teams = dataManager.fetchData(for: Club.self)
    }
    
    func addTarget() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapSpace))
        view.addGestureRecognizer(tapGesture)
    }
    
}



