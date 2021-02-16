//
//  MainViewController.swift
//  core_data_homework
//
//  Created by Андрей Груненков on 16.02.2021.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet weak var playersTable: UITableView!
    
    var dataManager: CoreDataManager!
    var players: [Player] = [] {
        didSet {
            playersTable.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updatePlayers()
    }
    
    @objc func addPlayerTapped() {
        let storyboard = UIStoryboard(name: "Player", bundle: Bundle.main)
        guard let playerViewController = storyboard.instantiateViewController(withIdentifier: String(describing: PlayerViewController.self)) as? PlayerViewController else {
            return
        }
        playerViewController.dataManager = dataManager
        self.navigationController?.pushViewController(playerViewController, animated: true)
    }
    
    func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let player = players[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            guard let _self = self else { return }
            _self.dataManager.delete(object: player)
            _self.updatePlayers()
        }
        return action
    }

    func updatePlayers() {
        players = dataManager.fetchData(for: Player.self)
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlayerCell.self)) as! PlayerCell
        let player = players[indexPath.row]
        cell.ageLabel.text = String(player.age)
        cell.nationalityLabel.text = player.nationality
        cell.playerFullname.text = player.fullname
        cell.positionLabel.text = player.position
        cell.playerNumber.text = player.number
        cell.teamLabel.text = player.club?.name 
        if let photo = player.image as? Data {
            cell.playerPhoto.image = UIImage(data: photo)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeConfig = UISwipeActionsConfiguration(actions: [self.contextualDeleteAction(forRowAtIndexPath: indexPath)])
        return swipeConfig
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
}

private extension MainViewController {
    
    func setupViews() {
        playersTable.delegate = self
        playersTable.dataSource = self
    }
    
    func setupNavigationBar() {
        let addPlayerItemView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 35))
        let addPlayerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 35))
        let addFolderTap = UITapGestureRecognizer(target: self, action: #selector(addPlayerTapped))
        addPlayerImageView.image = UIImage(systemName: "plus")
        addPlayerImageView.tintColor = UIColor.gray
        addPlayerItemView.addSubview(addPlayerImageView)
        addPlayerItemView.addGestureRecognizer(addFolderTap)
        let addPlayerItem = UIBarButtonItem(customView: addPlayerItemView)
        navigationItem.rightBarButtonItems = [addPlayerItem]
    }
    
}

