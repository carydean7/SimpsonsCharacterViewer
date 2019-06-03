//
//  DetailViewController.swift
//  SimpsonsCharacterViewer
//
//  Created by Dean Wagstaff on 1/30/19.
//  Copyright © 2019 Dean Wagstaff. All rights reserved.
//

import UIKit
import SimCharNetwork

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailVCHelper: DetailViewControllerHelper!
    
    var characterViewModel: CharacterViewModel?
    var indexPath = IndexPath(item: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        if let cViewModel = characterViewModel {
            self.view.addSubview(detailVCHelper.setupDetailViewControllerViewContent(for: cViewModel, withDataAt: indexPath))
        }
    }
}

