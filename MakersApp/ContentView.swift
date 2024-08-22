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
    @State private var audioRecorder: AVAudioRecorder?
    
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
            
            Text(isRecording ? "Go on. Don't Judge." : "Voice your thoughts")
                .font(.title3)
                .foregroundColor(.gray)
            
            if isRecording {
                Image(systemName: "waveform")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 50)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack {
                if isRecording {
                    Button(action: {
                        // Add action for left button
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(.gray)
                            .frame(width: 50, height: 50)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                
                Button(action: toggleRecording) {
                    Circle()
                        .fill(isRecording ? Color.white : Color.red)
                        .frame(width: 70, height: 70)
                        .overlay(
                            isRecording ?
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.red)
                                    .frame(width: 30, height: 30) :
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 60, height: 60)
                        )
                }
                
                if isRecording {
                    Button(action: {
                        // Add action for right button
                    }) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.gray)
                            .frame(width: 50, height: 50)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.bottom, 50)
        }
        .onAppear(perform: requestMicrophonePermission)
    }
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentsPath.appendingPathComponent("recording.m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            
            isRecording = true
            startTimer()
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        stopTimer()
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
    
    func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    print("Microphone permission granted")
                } else {
                    print("Microphone permission denied")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
