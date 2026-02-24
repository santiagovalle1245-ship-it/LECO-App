import Foundation
import AVFoundation
import Combine 

class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var recordingExists = false
    
    // Función para iniciar la grabación
    func startRecording() {
        // Configuración de la sesión de audio
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            print("Fallo al configurar sesión de audio")
        }
        
        // Dónde guardar el archivo
        let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = docPath.appendingPathComponent("lectura_temp.m4a")
        
        // Configuración de calidad
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            isRecording = true
            recordingExists = false
        } catch {
            print("No se pudo iniciar la grabación")
        }
    }
    
    // Función para detener la grabación
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        recordingExists = true
        audioRecorder = nil
    }
    
    // Función para reproducir lo grabado
    func startPlayback() {
        let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = docPath.appendingPathComponent("lectura_temp.m4a")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.delegate = self
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("No se pudo reproducir el audio")
        }
    }
    
    // Función para detener la reproducción
    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    // Cuando el audio termina de reproducirse solo
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}
