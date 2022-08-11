//
//  ToolBrain.swift
//  ToolTips
//
//  Created by Tatiana Kalintsev on 25/4/22.
//

import Foundation
import FirebaseDatabase

protocol ToolBrainDelegate {
    func didUpdateToolData(toolData: ToolBrain)
}

class ToolBrain {
    var delegate: ToolBrainDelegate?
    
    private let database = Database.database().reference()
    var machineNumber: Int = 100
    var VB: Double = 0.0
    var time: Double = 0.0
    var days: Int = 9
    var durability: Double = 0.0
    var VBArray: [Double] = [0.0]
    var times: [Double] = [0.0]
    var VBErrors: [Double] = [0.0]
    var VBErrorsLow: [Double] = [0.0]
    
    func formatTime(secs: Int) -> String {
        var hrStr = ""
        var minStr = ""
        var secStr = ""
        
        let sec = abs(secs)
        
        let hours   = floor(Double(sec) / 3600.0);
        let minutes = floor((Double(sec) - (hours * 3600.0)) / 60.0);
        let seconds = Double(sec) - (hours * 3600.0) - (minutes * 60.0);
        
        if hours == 1 {
            hrStr = "1 hr"
        } else if hours == 0 {
            hrStr = ""
        } else {
            hrStr = "\(Int(abs(hours))) hrs"
        }
            
        if minutes == 1 {
            minStr = "1 min"
        } else if minutes == 0 {
            minStr = ""
        } else {
            minStr = "\(Int(abs(minutes))) mins"
        }
        
        if seconds == 1 {
            secStr = "1 sec"
        } else if seconds == 0 {
            secStr = "0 secs"
        } else {
            secStr = "\(Int(abs(seconds))) secs"
        }
        
        let timeString = "\(hrStr) \(minStr) \(secStr)"
        
        let trimmedString = timeString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return trimmedString
            
    }
    
    func getPathway(material: String?, depth: String?, feed: String?) -> String {
        let formattedMat = (material?.lowercased())?.replacingOccurrences(of: " ", with: "_") ?? "test"
        
        var formattedDep = depth?.replacingOccurrences(of: " ", with: "_") ?? "test"
        formattedDep = formattedDep + "mm"
        formattedDep = formattedDep.replacingOccurrences(of: ".", with: "_")
        
        var formattedFeed = feed?.replacingOccurrences(of: " ", with: "_") ?? "test"
        formattedFeed = formattedFeed + "mm_rev"
        formattedFeed = formattedFeed.replacingOccurrences(of: ".", with: "_")
        
        let path = "machine_configurations/\(formattedMat)/\(formattedDep)/\(formattedFeed)"
        return path
    }
    
    func getMachineData(pathway: String) {
        
        // Get time array for use in graphing
        database.child("machine_configurations").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? NSDictionary else {
                return
            }
            self.times = value["times"]! as? [Double] ?? [0.0]
        })
        
        // Get Machine Dependent Variables
        database.child(pathway).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? NSDictionary else {
                return
            }
            // Write data into class properties
            self.machineNumber = value["machine_num"]! as? Int ?? 100
            self.VBArray = value["VB"]! as? [Double] ?? [0, 0, 0]
            self.VBErrors = value["VB_error"]! as? [Double] ?? [0, 0, 0]
            self.VB = value["curr_VB"] as? Double ?? 0.0
            self.time = value["curr_time"] as? Double ?? 0.0
            self.days = value["days_remaining"]! as? Int ?? 0
            self.durability = value["durability_remaining"]! as? Double ?? 0.0
            
            self.delegate?.didUpdateToolData(toolData: self)
        })
    }
}
