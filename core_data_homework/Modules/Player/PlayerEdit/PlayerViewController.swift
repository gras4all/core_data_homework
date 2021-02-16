//
//  PlayerViewController.swift
//  core_data_homework
//
//  Created by Андрей Груненков on 16.02.2021.
//

import UIKit

final class PlayerViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nationalityField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var selectTeamButton: UIButton!
    @IBOutlet weak var selectPositionButton: UIButton!
    @IBOutlet weak var numberField: UITextField!
    
    let positions = ["attack", "midfielder", "goalkeeper"]
    
    var team: Club?
    var position: String?
    var avatar: UIImage?
    
    let pickerController = UIImagePickerController()
    
    var dataManager: CoreDataManager!
    
    var teams: [Club] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPickers()
        self.setupPickersData()
        self.addTarget()
    }
    
    @IBAction func tapUploadImage(_ sender: Any) {
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func tapSelectTeamButton(_ sender: Any) {
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
    
    @IBAction func tapPositionButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Common", bundle: Bundle.main)
        guard let itemSelectorViewController = storyboard.instantiateViewController(withIdentifier: String(describing: ItemSelectorViewController.self)) as? ItemSelectorViewController else {
            return
        }
        itemSelectorViewController.modalTransitionStyle = .crossDissolve
        itemSelectorViewController.modalPresentationStyle = .overFullScreen
        itemSelectorViewController.items = positions
        itemSelectorViewController.itemSelected = { [weak self] row in
            guard let _self = self else { return }
            _self.position = _self.positions[row]
            UIView.performWithoutAnimation {
                _self.selectPositionButton.setTitle(_self.positions[row], for: .normal)
            }
            itemSelectorViewController.dismiss(animated: true, completion: nil)
        }
        self.present(itemSelectorViewController, animated: true, completion: nil)
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        let context = dataManager.getContext()
        let player = dataManager.createObject(from: Player.self)
        player.fullname = nameField.text
        player.nationality = nationalityField.text
        player.number = numberField.text
        player.club = team
        if let age = Int16(ageField.text ?? "") {
            player.age = age
        }
        player.position = position
        if let _avatar = avatar {
            player.image = _avatar.pngData() as NSObject?
        }
        dataManager.save(context: context)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTapSpace() {
        view.endEditing(true)
    }
    
}

extension PlayerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        photoImageView.image = image
        avatar = image
        pickerController.dismiss(animated: true, completion: nil)
    }
}

private extension PlayerViewController {
    
    func setupPickers() {
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.modalTransitionStyle = .crossDissolve
        pickerController.modalPresentationStyle = .overFullScreen
    }
    
    func setupPickersData() {
        self.teams = dataManager.fetchData(for: Club.self)
    }
    
    func addTarget() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapSpace))
        view.addGestureRecognizer(tapGesture)
    }
    
}


