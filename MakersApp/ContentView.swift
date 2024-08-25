//
//  ContentView.swift
//  MakersApp
//
//  Created by akhil-19050 on 21/08/24.
//

import SwiftUI
import AVFoundation


struct ContentView: View {
    @State private var timerValue = 0
    @State private var isRecording = false
    @State private var timer: Timer?
    @State private var microphonePermission: AVAudioSession.RecordPermission = .undetermined
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // Add menu action here
                }) {
                    Image(systemName: "line.horizontal.3")
                }
                Spacer()
                Button(action: {
                    // Add calendar action here
                }) {
                    Image(systemName: "calendar")
                }
            }
            .padding()
            
            Spacer()
            
            Text(timeString(from: timerValue))
                .font(.system(size: 48, weight: .thin))
                .padding()
            
            Text("Voice your thoughts")
                .font(.title3)
                .foregroundColor(.gray)
            
            Spacer()
            
            Button(action: toggleRecording) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 70, height: 70)
            }
            .padding(.bottom, 50)
        }
        
        
        var microphonePermissionStatus: String {
            switch microphonePermission {
            case .undetermined:
                return "Not Determined"
            case .granted:
                return "Granted"
            case .denied:
                return "Denied"
            @unknown default:
                return "Unknown"
            }
        }
    }
    
    func toggleRecording() {
        isRecording.toggle()
        if isRecording {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    func startTimer() {
        timerValue = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timerValue += 1
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func timeString(from seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func requestMicrophonePermission() {
         AVAudioSession.sharedInstance().requestRecordPermission { granted in
             DispatchQueue.main.async {
                 self.microphonePermission = granted ? .granted : .denied
             }
         }
     }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    

    

}
