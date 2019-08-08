//
//  ViewController.swift
//  VRLevelController
//
//  Created by vromano84 on 08/06/2019.
//  Copyright (c) 2019 vromano84. All rights reserved.
//

import UIKit
import VRLevelController;

class ViewController: UIViewController, VRLevelControllerDelegate {
    
    @IBOutlet weak var volumeButton: VRLevelButton!
    @IBOutlet weak var customButton: VRLevelButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volumeButton.config([
            "mainIcon": UIImage.init(named: "ic_sound_off")!,
            "stepIcons": [
                UIImage.init(named: "ic_sound_off")!,
                UIImage.init(named: "ic_sound_1")!,
                UIImage.init(named: "ic_sound_2")!,
                UIImage.init(named: "ic_sound_3")!
            ],
            "defaultValue": 0.0,
            "color": UIColor.green,
            "type": VRLevelButtonType.volume
        ]);
        
        customButton.config([
            "mainIcon": UIImage.init(named: "ic_mood")!,
            "stepIcons": [
                UIImage.init(named: "ic_mood_1")!,
                UIImage.init(named: "ic_mood_2")!,
                UIImage.init(named: "ic_mood_3")!
            ],
            "defaultValue": 0.0,
            "color": UIColor.blue,
            "type": VRLevelButtonType.custom
        ]);
        
    }
    
    func onValueChanged(sender: VRLevelButton, value: Float) {
        debugPrint("change \(sender) : \(value)");
    }
    
    func onDismiss(sender: VRLevelButton, value: Float) {
        debugPrint("dismiss \(sender) : \(value)");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

