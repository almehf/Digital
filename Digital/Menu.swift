//
//  Menu.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 3/27/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import UIKit

class Menu : UITableViewController {
    
    let menuOptions = ["Open Modal", "Open Push"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

// MARK: - UITableViewDelegate methods

extension Menu {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            // ContainerVC.swift listens for this
            NotificationCenter.default.post(name: Notification.Name(rawValue: "openModalWindow"), object: nil)
        case 1:
            // Both FirstViewController and SecondViewController listen for this
            NotificationCenter.default.post(name: Notification.Name(rawValue: "openPushWindow"), object: nil)
        default:
            print("indexPath.row:: \(indexPath.row)")
        }
        
        // also close the menu
        NotificationCenter.default.post(name: Notification.Name(rawValue: "closeMenuViaNotification"), object: nil)
        
    }
    
}

// MARK: - UITableViewDataSource methods

extension Menu {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuOptions[indexPath.row]
        return cell
    }
    
}
