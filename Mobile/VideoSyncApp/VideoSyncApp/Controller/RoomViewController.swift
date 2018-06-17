//
//  ViewController.swift
//  VideoSyncApp
//
//  Created by Salman Fakhri on 6/5/18.
//  Copyright © 2018 Salman Fakhri. All rights reserved.
//

import UIKit
import SocketIO
import YouTubePlayer

class RoomViewController: UIViewController {
    
    unowned var roomView: RoomView { return self.view as! RoomView }
    unowned var playerView: YouTubePlayerView { return roomView.playerView }
    unowned var usersTableView: UITableView { return roomView.usersTableView }
    
    lazy var videoSelectionLauncher = VideoSelectionLauncher()
    
    var connections: [Connection] = [Connection(name: "salman"), Connection(name: "salman"), Connection(name: "salman"), Connection(name: "salman"), Connection(name: "salman")] {
        didSet {
            print("changed connections data")
            print(connections)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = RoomView(frame: view.frame)
        usersTableView.dataSource = self
        setUpPlayerView()
        setUpSocket()
        view.backgroundColor = .white
        loadVideoWithURL(urlString: "https://www.youtube.com/watch?v=hHApdmoYsY8")
    }
}

// MARK: YoutubePlayer Delegate
extension RoomViewController: YouTubePlayerDelegate {
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        print(playerState)
    }
}

// MARK: UsersTableView DataSource
extension RoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.reuseIdentifier) as? HeaderCell {
                cell.delegate = self
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ConnectionCell.reuseIdentifier) as? ConnectionCell {
                return cell
            }
        }
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return connections.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        default:
            return 60
        }
    }
}

// MARK: Socket Delegate
extension RoomViewController: SocketEventDelegate {
    func didGetConnectionsData(connections: [Connection]) {
        self.connections = connections
        DispatchQueue.main.async {
            self.usersTableView.reloadData()
        }
    }
}

// MARK: HeaderCellDelegate

extension RoomViewController: HeaderCellDelegate {
    func didSelectVideoButton() {
        videoSelectionLauncher.showSelectionView()
    }
}

// MARK: Page Setup
extension RoomViewController {
    func loadVideoWithURL(urlString: String) {
        if let url = URL(string: urlString) {
            playerView.loadVideoURL(url)
        }
    }
    
    func setUpPlayerView() {
        playerView.playerVars["playsinline"] = "1" as AnyObject?
    }
    
    func setUpSocket() {
//        SocketClientManager.sharedInstance.setUpSocketManger()
//        SocketClientManager.sharedInstance.connectSocket()
//        SocketClientManager.sharedInstance.addHandlers()
        SocketClientManager.sharedInstance.eventDelegate = self
    }
}

