//
//  TransactionChartView.swift
//  ToolTips
//
//  Created by Tatiana Kalintsev on 10/5/2022.
//

import SwiftUI
import Charts

struct TransactionBarChartView: UIViewRepresentable {
    let entries:[BarChartDataEntry]
    
    func makeUIView(context: Context) -> BarChartView {
        return BarChartView()
    }
    
    func updateUIView(_ uiView: BarChartView, context: Context) {
        let dataSet = BarChartDataSet(entries: entries)
        uiView.data = BarChartData(dataSet: dataSet)
    }
    
}


struct TransactionChartView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionBarChartView(entries: Transaction.dataEntriesForYear(2019, transactions: Transaction.allTransactions))
    }
}
