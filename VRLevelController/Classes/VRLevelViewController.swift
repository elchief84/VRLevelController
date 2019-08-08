//
//  VRLevelViewController.swift
//  VRLevelController
//
//  Created by Vincenzo Romano on 06/08/2019.
//

import UIKit
import MediaPlayer

public protocol VRLevelControllerDelegate {
    func onValueChanged(sender:VRLevelButton, value:Float, step:Int);
    func onDismiss(sender:VRLevelButton, value:Float, step:Int);
}

public class VRLevelViewController: UIViewController {
    @IBOutlet weak var current_state_icon: UIImageView!;
    @IBOutlet weak var min_state_icon: UIImageView!;
    @IBOutlet weak var slider_wrapper: UIView!
    
    private var full:CALayer?;
    private var mask:CALayer?;
    
    private var panGesture:UIPanGestureRecognizer?;
    private var startY:CGFloat?;
    
    private var mainIcon:UIImage?;
    private var icons:Array<UIImage>?;
    private var value:CGFloat? = 0.0;
    private var type:VRLevelButtonType = VRLevelButtonType.volume;
    private var color:UIColor = .red;
    private var steps:Int = 0;
    private var currentStep:Int = 0;
    
    private var caller:VRLevelButton?;
    private var delegate:VRLevelControllerDelegate?;
    
    private var volumeView:MPVolumeView?;
    private var slider:UISlider?;
    
    private var obs: NSKeyValueObservation?
    private var audioSession:AVAudioSession?;
    
    private var isActive:Bool = false;
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        min_state_icon.image = mainIcon;
        current_state_icon.image = icons![0];
        
        full = CALayer();
        full?.frame = slider_wrapper.bounds;
        full?.backgroundColor = color.cgColor;
        
        mask = CALayer();
        mask?.frame = slider_wrapper.bounds;
        mask?.backgroundColor = UIColor.blue.cgColor;
        full?.mask = mask;
        
        if(type == .volume){
            self.value = CGFloat(audioSession!.outputVolume);
        }
        
        let offset = (1 - self.value!) * mask!.frame.size.height;
        mask?.transform = CATransform3DTranslate(mask!.transform, 0.0, offset, 0.0);
        
        self.setSliderValue(self.value!);
        
        slider_wrapper.layer.addSublayer(full!);
        
        self.delegate = (self.presentingViewController as! VRLevelControllerDelegate);
    }
    
    private func checkIcon() {
        let newStep = Int((self.value! - 0.01) * CGFloat(self.icons!.count));
        if(newStep == currentStep) {
            return;
        }
        currentStep = newStep;
        self.current_state_icon.image = self.icons![self.currentStep];
    }
    
    public func setCaller(_ caller:VRLevelButton) {
        self.caller = caller;
    }
    
    public func setMainIcon(_ icon:UIImage){
        self.mainIcon = icon;
    }
    
    public func setIcons(_ icons:Array<UIImage>){
        self.icons = icons;
        self.steps = icons.count;
    }
    
    public func setSliderValue(_ value:CGFloat) {
        let _value = (value < 0.0) ? 0.0 : ((value > 1.0) ? 1.0 : value);
        
        self.value = _value;
        
        if(type == .volume){
            self.setVolume(Float(self.value!));
        }
        
        if(mask != nil) {
            self.checkIcon();
        }
        
        delegate?.onValueChanged(sender: caller!, value: Float(self.value!), step: currentStep);
    }
    
    public func setType(_ type:VRLevelButtonType){
        self.type = type;
        
        if(type == .volume){
            volumeView = MPVolumeView(frame: .zero);
            slider = volumeView!.subviews.first(where: { $0 is UISlider }) as? UISlider;
            volumeView!.clipsToBounds = true;
            self.view.addSubview(volumeView!);
            
            audioSession = AVAudioSession.sharedInstance()
            try? audioSession!.setCategory(AVAudioSessionCategoryPlayback)
            try? audioSession!.setMode(AVAudioSessionModeDefault)
            try? audioSession!.setActive(true)
            self.obs = audioSession!.observe( \.outputVolume ) { (av, change) in
                var volume = CGFloat(av.outputVolume);
                volume = (volume < 0) ? 0.0 : ((volume > 1.0) ? 1.0 : volume);
                self.setSliderValue(volume);
                
                if(self.isActive == false){
                    let offset = (1.0 - volume) * (self.mask?.frame.size.height)!;
                    self.mask?.transform = CATransform3DMakeTranslation(0.0, offset, 0.0);
                }
            }
        }
    }
    
    public func setColor(_ color:UIColor){
        self.color = color;
    }
    
    func setVolume(_ volume: Float) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.00001) {
            self.slider!.value = volume;
        }
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.first != nil){
            let point:CGPoint = (touches.first?.location(in: self.view))!;
            
            if(slider_wrapper.frame.contains(point)){
                isActive = true;
                startY = point.y;
            }else{
                self.dismiss(animated: true) {
                    self.delegate?.onDismiss(sender: self.caller!, value: Float(1.0 - self.value!), step: self.currentStep);
                }
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(isActive) {
            if(touches.first != nil){
                let currentY:CGFloat = touches.first!.location(in: self.view).y;
                
                var delta = currentY - startY!;
                delta = (((mask?.transform.m42)! + delta) < 0) ? 0 : delta;
                delta = (((mask?.transform.m42)! + delta) > (mask?.frame.size.height)!) ? 0 : delta;
                
                mask?.transform = CATransform3DTranslate(mask!.transform, 0.0, delta, 0.0);
                
                self.value = 1.0 - (mask?.transform.m42)! / (mask?.frame.size.height)!;
                self.setSliderValue(self.value!);
                
                startY = currentY;
            }
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isActive = false;
    }
    
}
