//
//  protocal.swift
//  IRRemote_V6
//
//  Created by Yuchao Chen on 4/29/16.
//  Copyright © 2016 Yuchao Chen. All rights reserved.
//


import Foundation
import AVFoundation

class Protocal: AVAudioPlayerNode {
    //this size could draw a whole circle
    let bufferCapacity: AVAudioFrameCount = 352 * 8
    let sampleRate: Double = 44_100.0
    
    var frequency: Double = 440.0
    var amplitude: Double = 0.7
    
    private var theta: Double = 0.0
    private var audioFormat: AVAudioFormat!
    
    override init() {
        super.init()
        audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)
    }
    
    func prepareBufferOne() -> AVAudioPCMBuffer {
        let buffer = AVAudioPCMBuffer(PCMFormat: audioFormat, frameCapacity: bufferCapacity)
        fillBufferOne(buffer)
        return buffer
    }
    
    func prepareBufferZero() -> AVAudioPCMBuffer {
        let buffer = AVAudioPCMBuffer(PCMFormat: audioFormat, frameCapacity: bufferCapacity)
        fillBufferZero(buffer)
        return buffer
    }
    
    func fillBufferZero(buffer: AVAudioPCMBuffer) {
        let data = buffer.floatChannelData[0]
        let numberFrames = buffer.frameCapacity / 8
        var theta = 0.0
        let theta_increment = 2.0 * M_PI * self.frequency / self.sampleRate
        
        for frame in 0..<Int(numberFrames) {
            data[frame] = Float32(sin(theta) * amplitude)
            
            theta += theta_increment
            if theta > 2.0 * M_PI {
                theta -= 2.0 * M_PI
            }
        }
        for otherFrame in Int(numberFrames)..<(Int(numberFrames)*8){
            data[otherFrame] = 0
        }
        buffer.frameLength = numberFrames * 8
        self.theta = theta
    }
    func fillBufferOne(buffer: AVAudioPCMBuffer) {
        let data = buffer.floatChannelData[0]
        let numberFrames = buffer.frameCapacity / 8
        var theta = 0.0
        let theta_increment = 2.0 * M_PI * self.frequency / self.sampleRate
        
        for frame in 0..<Int(numberFrames)*2 {
            data[frame] = Float32(sin(theta) * amplitude)
            
            theta += theta_increment
            if theta > 2.0 * M_PI {
                theta -= 2.0 * M_PI
            }
        }
        for otherFrame in Int(numberFrames)*2..<(Int(numberFrames)*8){
            data[otherFrame] = 0
        }
        buffer.frameLength = numberFrames * 8
        self.theta = theta
    }
    
    //through these two methods to get Logic one and zero
    
    func scheduleBufferOne(){
        
        func scheduleBuffer() {
            let bufferOne = prepareBufferOne()
            
            self.scheduleBuffer(bufferOne) {

            }
            
            
        }
        scheduleBuffer()
        
    }
    func scheduleBufferZero(){
        
        func scheduleBuffer() {
            
            let bufferZero = prepareBufferZero()
            
            self.scheduleBuffer(bufferZero){
                
            }
            
        }
        scheduleBuffer()
        
    }
    
//    func loadingBuffers() {
//        scheduleBufferOne()
//        scheduleBufferZero()
//
//    }
}

