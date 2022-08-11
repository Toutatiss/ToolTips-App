//
//  ViewController.swift
//  ToolTips
//
//  Created by Tatiana Kalintsev on 28/3/22.
//

import UIKit
import FirebaseDatabase

private let database = Database.database().reference()

class ToolStateViewController: UIViewController {

    private let database = Database.database().reference()
    // Display variables
    var machineNumber: String? = ""
    var VB: Double? = 0.0
    var time: Double? = 0.0
    var durability: Double? = 0.0
    var days: Int? = 0
    
    // Declare toolbrain for use in refresh operation
    var toolBrain = ToolBrain()
    var path: String? = "" // grab previous pathway for use in refresh operation
    
    // Variables to pass to graphing function
    var times: [Double] = [0.0]
    var VBArray: [Double] = [0.0]
    var VBErrors: [Double] = [0.0]
    
    // Selected parameter labels
    var selectedMaterial: String = ""
    var selectedDepth: String = ""
    var selectedFeed: String = ""
    
    // Custom colour
    let textColour: UIColor = .init(red: 173/255, green: 139/255, blue: 115/255, alpha: 1)
    
    @IBOutlet weak var refreshLoadWheel: UIActivityIndicatorView!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var machineNumberLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var lifetimeLabel: UILabel!
    @IBOutlet weak var toolStateProgress: UIProgressView!
    @IBOutlet weak var toolStateProgress2: UIProgressView!
    
    @IBOutlet weak var materialLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var feedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshLoadWheel.hidesWhenStopped = true
        refreshLoadWheel.stopAnimating()
        toolBrain.delegate = self
        refreshDisplay()
    }
    
    @IBAction func refreshWasPressed(_ sender: Any) {
        refreshLoadWheel.startAnimating()
        toolBrain.getMachineData(pathway: path!)
    }
    
    @IBAction func viewGraphsWasPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToGraphs", sender: self)
    
    }
    
    func refreshDisplay() {
        machineNumberLabel.text = "Machine Number: \(machineNumber!)"
        materialLabel.text = "Material: \(selectedMaterial)"
        depthLabel.text = "Depth of Cut: \(selectedDepth) mm"
        feedLabel.text = "Feed Rate: \(selectedFeed) mm/rev"
        percentageLabel.text = "\(Float(durability! * 100))%"
        statusLabel.text = "\(VB!) mm"
        
        let timeRemaining = toolBrain.formatTime(secs: days!)
        
        if days! < 0 {
            lifetimeLabel.textColor = .systemPink
            lifetimeLabel.text = "\(timeRemaining) ago"
        } else {
            lifetimeLabel.textColor = textColour
            lifetimeLabel.text = "\(timeRemaining)"
        }
                
        if durability! == 0 {
            warningLabel.text = "Warning: Tool has been worn out! Replacement is overdue"
        } else if durability! <= 0.1 {
            warningLabel.text = "Warning: Tool will be worn out soon! Replacement is due"
        } else {
            warningLabel.text = ""
        }
        

//        toolStateProgress.transform = CGAffineTransform(rotationAngle: .pi / 2)
        toolStateProgress.progress = Float(durability!)
        toolStateProgress2.progress = toolStateProgress.progress
    }
    
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGraphs" {
            let destinationVC = segue.destination as! GraphViewController
            destinationVC.times = self.times
            destinationVC.wear = VBArray
            destinationVC.VBErrors = VBErrors
            destinationVC.currVB = VB
            destinationVC.currTime = time
        }
    }
    
}

extension ToolStateViewController: ToolBrainDelegate {
    func didUpdateToolData(toolData: ToolBrain) {
        DispatchQueue.main.async {
            self.machineNumber = String(self.toolBrain.machineNumber)
            self.VB = self.toolBrain.VB
            self.durability = self.toolBrain.durability
            self.days = self.toolBrain.days
            self.time = self.toolBrain.time
            
            self.refreshLoadWheel.stopAnimating()
            self.refreshDisplay()
        }
    }
}
    
    
// DATABASE TEST CODE:
    
//        print("testWasPressedlol")
//        database.child("machine_configurations/cast_iron/0_75mm/0_25mm_rev").observeSingleEvent(of: .value, with: { snapshot in
//                      guard let value = snapshot.value as? NSDictionary else {
//                          return
//                      }
//                      print("Value: \(value)")
//                      self.testVal = value["VB"]! as! [Double]
//                      print("VB Array: \(self.testVal)")
//                      print("Last Value: \(self.testVal.last)")
//                  })
//
//                  print("Test was pressed:")





// code that writes to the database
//        let object: [String: Any] = ["name": "tester" as NSObject, "age": "testing"]
//        database.child("test").setValue(object)



//    code that reads from the database
//          database.child("machine_configurations/steel/0_75mm/0_25mm_rev").observeSingleEvent(of: .value, with: { snapshot in
//              guard let value = snapshot.value as? NSDictionary else {
//                  return
//              }
//  //            print("Value: \(value)")
//              self.mat = value["machine_num"]! as! Int
//              self.doc = value["VB"]! as! Double
//  //            self.feed = value["feed_rate"]! as! Float
//  //            self.vb = value["feed_rate"]! as! Float
//
//  //            print("Extracted data for machine number: \(self.machineNumber!)")
//              print("Material: \(self.mat)")
//              print("Depth of Cut: \(self.doc)")
//  //            print("Feed Rate: \(self.feed)")
//  //            print("VB: \(self.vb)")
//          })
//
//          print("Test was pressed:")



