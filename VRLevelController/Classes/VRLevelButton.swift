//
//  VRLevelButton.swift
//  VRLevelController
//
//  Created by Vincenzo Romano on 06/08/2019.
//

import UIKit

public enum VRLevelButtonType {
    case volume
    case custom
}

public class VRLevelButton: UIButton {
    
    private var baseController:UIViewController?;
    private var levelController:VRLevelViewController?;
    
    private var mainIcon:UIImage?;
    private var icons:Array<UIImage>?;
    private var value:CGFloat = 0.0;
    private var type:VRLevelButtonType = VRLevelButtonType.volume;
    private var color:UIColor = .red;
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        assert(icons != nil, "Please call setIcons() method with icon UIImage's array");
        assert(icons!.count >= 2, "Needs min 2 icons! call setIcons() method with a valid UIImage's array");
        
        baseController = self.findViewController(responder: self);
        
        assert(baseController != nil, "Please check your VRLevelButton! It seems not attached in the display list!")
        
        levelController = (UIStoryboard.init(name: "VRLevelStoryboard", bundle: Bundle(for: VRLevelButton.self)).instantiateViewController(withIdentifier: "vrlevelcontroller") as! VRLevelViewController);
        
        levelController?.setType(type);
        levelController?.setMainIcon(mainIcon!);
        levelController?.setIcons(icons!);
        levelController?.setSliderValue(value);
        levelController?.setColor(color);
        levelController!.modalPresentationStyle = .overFullScreen;
        levelController!.modalTransitionStyle = .crossDissolve;
        levelController!.setCaller(self);
        baseController!.present(levelController!, animated: true, completion: nil);
    }
    
    public func config(_ config:[String:Any]) -> Void {
        assert(config["stepIcons"] != nil, "stepIcons field missing in your configuration!");
        assert((config["stepIcons"] as! Array<UIImage>).count >= 2, "Needs min 2 icons! pass UIImage with images arrays in stepIcons field");
        
        setIcons(config["stepIcons"] as! Array<UIImage>);
        
        assert(config["mainIcon"] != nil, "mainIcon field missing in your configuration!");
        setMainIcon(config["mainIcon"] as! UIImage);
        
        if(config["defaultValue"] != nil){
            setValue(CGFloat((config["defaultValue"] as! NSNumber).floatValue));
        }
        
        if(config["type"] != nil){
            setType(config["type"] as! VRLevelButtonType);
        }
        
        if(config["color"] != nil){
            setColor(config["color"] as! UIColor);
        }
    }
    
    private  func setMainIcon(_ icon:UIImage){
        self.mainIcon = icon;
    }
    
    private  func setIcons(_ icons:Array<UIImage>){
        self.icons = icons;
    }
    
    private func setValue(_ value:CGFloat){
        assert(value >= 0.0, "Invalid value! Value must be contained in 0.0 ~ 1.0 interval");
        assert(value <= 1.0, "Invalid value! Value must be contained in 0.0 ~ 1.0 interval");
        
        self.value = value;
        if(levelController != nil){
            levelController?.setSliderValue(value)
        }
    }
    
    private func setType(_ type:VRLevelButtonType){
        self.type = type;
    }
    
    private func getType(_ type:VRLevelButtonType) -> VRLevelButtonType{
        return self.type;
    }
    
    private  func setColor(_ color:UIColor){
        self.color = color;
    }
    
    private func findViewController(responder: UIResponder) -> UIViewController? {
        if let vc = responder as? UIViewController {
            return vc;
        }
        
        if let next = responder.next {
            return findViewController(responder: next);
        }
        
        return nil;
    }

}
