//
//  ContentView.swift
//  BetterRest
//
//  Created by Thaddeus Dronski on 12/9/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var body: some View {
        //View
        NavigationView {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("How much coffee do you drink?")
                    .font(.headline)
                Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
        }
    }
    
    //Functionality
    
    func calculateBedTime() {
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



//Stepper
//struct ContentView: View {
//    @State private var sleepAmount = 8.0
//    var body: some View {
//        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
//    }
//}

////DatePicker
//
//struct ContentView: View {
//    @State private var wakeUp = Date.now
//    var body: some View {
//        DatePicker("Please enter a date", selection: $wakeUp, in: Date.now..., displayedComponents: .date)
//            .labelsHidden()
//    }
//}

//struct ContentView: View {
//    var body: some View {
//        Text(Date.now.formatted(date: .long, time: .omitted))
//    }
//
//    func trivialExample() {
//        let components = Calendar.current.dateComponents([.hour, .minute], from: Date.now)
//        let hour = components.hour ?? 0
//        let minutes = components.minute ?? 0
//    }
//}
