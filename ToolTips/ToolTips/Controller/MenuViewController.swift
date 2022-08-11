//
//  MenuViewController.swift
//  ToolTips
//
//  Created by Tatiana Kalintsev on 20/4/22.
//

import UIKit
import Foundation

class MenuViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var configPicker: UIPickerView!
    
    @IBOutlet weak var loadingDataIndicator: UIActivityIndicatorView!
    
    var toolModel = ToolModel()
    var toolBrain = ToolBrain()
    var path: String = ""
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolBrain.delegate = self
        configPicker.delegate = self
        configPicker.dataSource = self
        
        loadingDataIndicator.hidesWhenStopped = true
        loadingDataIndicator.stopAnimating()
        
        toolModel.selectedMaterial = toolModel.materials[0]
        toolModel.selectedDepth = toolModel.depths[0]
        toolModel.selectedFeedRate = toolModel.feeds[0]
    }
    
    
    @IBAction func confirmWasPressed(_ sender: UIButton) {
        loadingDataIndicator.startAnimating()
        
        if toolModel.selectedMaterial != nil {
            print(toolModel.selectedMaterial!)
            print(toolModel.selectedDepth!)
            print(toolModel.selectedFeedRate!)
            
//            toolBrain.getAllData()
            
            path = toolBrain.getPathway(material: toolModel.selectedMaterial, depth: toolModel.selectedDepth, feed: toolModel.selectedFeedRate)
            
            print("Pathway: \(path)")
            toolBrain.getMachineData(pathway: path)
            
//            let seconds = 1.5
//            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
//                self.loadingDataIndicator.stopAnimating()
//                print("Machine Number: \(self.toolBrain.machineNumber)")
//                print("VB: \(self.toolBrain.VB)")
//                self.performSegue(withIdentifier: "goToToolState", sender: self)
//            }
        }
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3 // how many columns to include
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        switch component {
        case 0:
            return toolModel.materials.count
        case 1:
            return toolModel.depths.count
        case 2:
            return toolModel.feeds.count
        default:
            return 1;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return toolModel.materials[row]
        case 1:
            return toolModel.depths[row]
        case 2:
            return toolModel.feeds[row]
        default:
            return "no data"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            toolModel.selectedMaterial = toolModel.materials[row]
        case 1:
            toolModel.selectedDepth = toolModel.depths[row]
        case 2:
            toolModel.selectedFeedRate = toolModel.feeds[row]
        default:
            print("Error occurred in didSelectRow")
        }
        
        path = toolBrain.getPathway(material: toolModel.selectedMaterial, depth: toolModel.selectedDepth, feed: toolModel.selectedFeedRate)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToToolState" {
            let destinationVC = segue.destination as! ToolStateViewController
            destinationVC.machineNumber = String(toolBrain.machineNumber)
            destinationVC.VB = toolBrain.VB
            destinationVC.time = toolBrain.time
            destinationVC.durability = toolBrain.durability
            destinationVC.days = toolBrain.days
            destinationVC.selectedMaterial = toolModel.selectedMaterial ?? "unknown"
            destinationVC.selectedDepth = toolModel.selectedDepth ?? "unknown"
            destinationVC.selectedFeed = toolModel.selectedFeedRate ?? "unknown"
            destinationVC.times = toolBrain.times
            destinationVC.VBArray = toolBrain.VBArray
            destinationVC.VBErrors = toolBrain.VBErrors
            destinationVC.path = path
        }
    }
}


extension MenuViewController: ToolBrainDelegate {
    func didUpdateToolData(toolData: ToolBrain) {
        DispatchQueue.main.async {
            self.loadingDataIndicator.stopAnimating()
            print("Machine Number: \(self.toolBrain.machineNumber)")
            print("VB: \(self.toolBrain.VB)")
            self.performSegue(withIdentifier: "goToToolState", sender: self)
        }
    }
}
