//
//  Audio.swift
//  Incoming and Outgoing Calls Demo
//
//  Created by AbdurRehmanNineSol on 22/09/2022.
//


import AVFoundation

func configureAudioSession() {
  print("Configuring audio session")
  let session = AVAudioSession.sharedInstance()
  do {
    try session.setCategory(.playAndRecord, mode: .voiceChat, options: [])
  } catch (let error) {
    print("Error while configuring audio session: \(error)")
  }
}

func startAudio() {
  print("Starting audio")
}

func stopAudio() {
  print("Stopping audio")
}
