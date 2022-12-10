//
//  ContentView.swift
//  BetterRest
//
//  Created by Thaddeus Dronski on 12/9/22.
//
import CoreML
import SwiftUI


struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    
    var sleepResults: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            return sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            //something went wrong
            return "There was an error "
        }
    }
    
    var body: some View {
        //View
        NavigationView {
            VStack {
                Form {
                    Section {
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    } header: {
                        Text("When do you want to wake up?")
                    }
                    Section {
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    } header: {
                        Text("Desired amount of sleep")
                    }
                    Section {
    //                    Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                        Picker("Cups of Coffee", selection: $coffeeAmount) {
                            ForEach(1..<21) {
                                Text(String($0))
                            }
                        }
                    } header: {
                        Text("How much coffee do you drink?")
                    }
                 }
                VStack {
                    Text("Your ideal bed time is:")
                        .font(.title3)
                    Text(sleepResults)
                        .font(.title.weight(.bold))
                }
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
           .navigationTitle("BetterRest")
        }
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
