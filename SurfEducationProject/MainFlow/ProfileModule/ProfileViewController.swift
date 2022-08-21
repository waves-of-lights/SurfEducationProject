//
//  ProfileViewController.swift
//  SurfEducationProject
//
//  Created by Anastasia Anisimova on 21.08.2022.
//

import UIKit

final class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var exitButton: UIButton!
    
    // MARK: - Public
    var userInfo: UserInfo?
    var onFinish: (() -> Void)?
    
    // MARK: - Private
    private var items: [ProfileScreenProtocol] = []

    // MARK: - Lifeсyrcle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль"
        tableView.registerCell(with: ProfileInfoTableViewCell.self)
        tableView.registerCell(with: ProfileNameTableViewCell.self)
        if let data = UserDefaults.standard.data(forKey: "user_info") {
            do {
                let decoder = JSONDecoder()
                userInfo = try decoder.decode(UserInfo.self, from: data)
                configureItems()
                tableView.reloadData()

            } catch {
                print("Unable to Decode (\(error))")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ProfileScreenBaseCell
        
        switch items[indexPath.row].type {
        case .address:
            cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoTableViewCell.nameOfClass) as! ProfileInfoTableViewCell
            
        case .email:
            cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoTableViewCell.nameOfClass) as! ProfileInfoTableViewCell
            
        case .phone:
            cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoTableViewCell.nameOfClass) as! ProfileInfoTableViewCell
            
        case .name:
            cell = tableView.dequeueReusableCell(withIdentifier: ProfileNameTableViewCell.nameOfClass) as! ProfileNameTableViewCell
            
        }
        cell.model = items[indexPath.row]
        return cell
    }
    
    // MARK: - Private
    private func configureItems() {
        
        guard let profileInfo = userInfo else {
            return
        }
        items.append(ProfileNameItem(type: .name, avatarURLString: profileInfo.avatar, firstName: profileInfo.firstName, secondName: profileInfo.lastName, phrase: profileInfo.about))
        items.append(ProfileInfoItem(type: .address, subtitle: profileInfo.city))
        items.append(ProfileInfoItem(type: .phone, subtitle: profileInfo.phone))
        items.append(ProfileInfoItem(type: .email, subtitle: profileInfo.email))
    }
}

// MARK: - Actions
private extension ProfileViewController {
    @IBAction func exitAction(_ sender: UIButton) {
        exitButton.alpha = 1.0
        UserDefaults.standard.removeObject(forKey: "user_info")
        try? BaseTokenStorage().removeTokenFromContainer()
        onFinish?()
    }
    
    @IBAction func exitActionDown(_ sender: UIButton) {
        exitButton.alpha = 0.5
    }
}
