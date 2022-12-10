//
//  ContentView.swift
//  BetterRest
//
//  Created by Thaddeus Dronski on 12/9/22.
//
import CoreML
import SwiftUI


struct ContentView: View {
    
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTite = ""
    @State private var alertMSG = ""
    @State private var showAlert = false
    
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
            .alert(alertTite, isPresented: $showAlert) {
                Button("OK") {}
            } message: {
                Text(alertMSG)
            }
        }
    }
    
    //Functionality
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTite = "Your ideal bedtime is...."
            alertMSG = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            //something went wrong
            alertTite = "Error"
            alertMSG = "Sorry there was an issue calculating bed time"
        }
        
        showAlert = true
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
