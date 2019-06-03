//
//  DetailViewControllerHelper.swift
//  SimpsonsCharacterViewer
//
//  Created by Dean Wagstaff on 5/21/19.
//  Copyright © 2019 Dean Wagstaff. All rights reserved.
//

import UIKit
import SimCharNetwork

class DetailViewControllerHelper: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var characterImageView: UIImageView!
    
    var characterViewModel: CharacterViewModel?
    
    func setupDetailViewControllerViewContent(for viewModel: CharacterViewModel?, withDataAt indexPath: IndexPath) -> UIView {
        self.isUserInteractionEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
        nameLabel.text = viewModel?.characterNameToDisplay(for:indexPath)
        descriptionTextView.text = viewModel?.characterDescriptionToDisplay(for: indexPath)
        
        viewModel?.getCharacterImage(for: indexPath, completion: { (successful) in
            if successful {
                self.characterImageView.image = viewModel?.characterImageToDisplay().image
            }
        })

        return self
    }
}
