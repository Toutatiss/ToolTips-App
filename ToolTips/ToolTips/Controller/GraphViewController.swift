//
//  GraphViewController.swift
//  ToolTips
//
//  Created by Tatiana Kalintsev on 30/4/2022.
//

import UIKit
import Charts

class GraphViewController: UIViewController {

    var times: [Double] = [1, 2, 3]
    var wear: [Double] = [1, 2, 3]
    var VBErrors: [Double] = [1, 2, 3]
    var errUpper: [Double] = [1, 2, 3]
    var errLower: [Double] = [1, 2, 3]

    var currTime: Double? = 0.0
    var currVB: Double? = 0.0
    
    var testx: [Double] = [1, 2, 3]
    var texty: [Double] = [1, 2, 3]
    
    let darkAccent: UIColor = .init(red: 22/255, green: 54/255, blue: 58/255, alpha: 0.5)
    
    let accentColour: UIColor = .init(red: 84/255, green: 186/255, blue: 185/255, alpha: 1)
    
    let lightAccentColour: UIColor = .init(red: 84/255, green: 186/255, blue: 185/255, alpha: 0.1)
    
    let textColour: UIColor = .init(red: 173/255, green: 139/255, blue: 115/255, alpha: 1)
    

    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        
        errUpper = times
        errLower = times
        
        for i in 0...times.count-1 {
          errUpper[i] = wear[i] + VBErrors[i]
          errLower[i] = abs(wear[i] - VBErrors[i])
        }
        
        super.viewDidLoad()
//        lineChartView.marker = true
        lineChartView.animate(xAxisDuration: 1.5)
        
        lineChartView.highlightPerDragEnabled = true
        
        lineChartView.backgroundColor = lightAccentColour
        lineChartView.legend.textColor = textColour
        
        lineChartView.xAxis.labelTextColor = textColour
        lineChartView.xAxis.gridColor = textColour
        
        lineChartView.leftAxis.labelTextColor = textColour
        lineChartView.leftAxis.gridColor = textColour
        
        lineChartView.rightAxis.labelTextColor = textColour
        lineChartView.rightAxis.gridColor = textColour
        
        setChartValues()
    }
    
    
    func setChartValues() {
        
        // Step 1: Initialise LineChartData (non-repeating)
        let data = LineChartData()
        
        // Step 2: Initialise data entry for line
        var dataEntry1: [ChartDataEntry] = []

        // Step 2.5: Populate the data entry with data
        for i in 0..<times.count {
          let dataEntry = ChartDataEntry(x: times[i], y: wear[i])
          dataEntry1.append(dataEntry)
        }

        // Step 3: Initialise the line's dataset
        let wearLine = LineChartDataSet(entries: dataEntry1, label: "Tool Wear (mm)")

        // Step 4: add the dataset to the chart
        data.addDataSet(wearLine)
        
        // Single Point:
        var pointEntry: [ChartDataEntry] = []
        pointEntry.append(ChartDataEntry(x: currTime!, y: currVB!))
        let currPoint = LineChartDataSet(entries: pointEntry, label: "Current Wear")
        data.addDataSet(currPoint)
        

        // Upper Error:
        var dataEntry2: [ChartDataEntry] = []

        for i in 0..<times.count {
          let dataEntry = ChartDataEntry(x: times[i], y: errUpper[i])
          dataEntry2.append(dataEntry)
        }
        let errUpperLine = LineChartDataSet(entries: dataEntry2, label: "Error Upper")

        data.addDataSet(errUpperLine)
        
        // Lower Error:
        var dataEntry3: [ChartDataEntry] = []
        
        for i in 0..<times.count {
          let dataEntry = ChartDataEntry(x: times[i], y: errLower[i])
          dataEntry3.append(dataEntry)
        }
        let errLowerLine = LineChartDataSet(entries: dataEntry3, label: "Error Lower")
        
        data.addDataSet(errLowerLine)
        
        // Max Wear Line:
        var entry: [ChartDataEntry] = []
        entry.append(ChartDataEntry(x: 0.0, y: 1.5))
        entry.append(ChartDataEntry(x: 100.0, y: 1.5))
        let wearLimitLine = LineChartDataSet(entries: entry, label: "Wear Limit")
        data.addDataSet(wearLimitLine)
        
        
        // Aesthetic Options
        wearLimitLine.drawCirclesEnabled = false
        wearLimitLine.setColor(textColour)
        wearLimitLine.lineWidth = 2
        wearLimitLine.lineDashLengths = [5]
        
        currPoint.drawValuesEnabled = true
        currPoint.valueColors = [textColour]
        currPoint.circleRadius = 5
        
        
        errUpperLine.drawCirclesEnabled = false
        errUpperLine.lineWidth = 1
        errUpperLine.setColor(accentColour)
        errUpperLine.lineDashLengths = [5]
        
        errLowerLine.drawCirclesEnabled = false
        errLowerLine.lineWidth = 1
        errLowerLine.setColor(accentColour)
        errLowerLine.lineDashLengths = [5]
        
        wearLine.drawCirclesEnabled = false
        wearLine.lineWidth = 3
        wearLine.setColor(darkAccent)
        
        wearLine.fill = Fill(color: .cyan)
        wearLine.fillAlpha = 0.2
        wearLine.drawFilledEnabled = true
        
        lineChartView.data = data
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
