//
//  CharacterDetailViewController.swift
//  SimpsonsCharacterViewer
//
//  Created by Dean Wagstaff on 1/31/19.
//  Copyright © 2019 Dean Wagstaff. All rights reserved.
//

import UIKit
import SimCharNetwork

class CharacterDetailViewController: UIViewController {
    
    var characterViewModel: CharacterViewModel?
    var indexPath = IndexPath(item: 0, section: 0)
    
    @IBOutlet weak var detailVCHelper: DetailViewControllerHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cViewModel = characterViewModel {
            self.view.addSubview(detailVCHelper.setupDetailViewControllerViewContent(for: cViewModel, withDataAt: indexPath))
        }
    }
}
