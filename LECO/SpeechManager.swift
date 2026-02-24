import Foundation
import AVFoundation
import Combine

class SpeechManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    // El sintetizador es el motor de IA que convierte texto a voz
    private let synthesizer = AVSpeechSynthesizer()
    
    // Variable para saber si está hablando o no (para cambiar el ícono del botón)
    @Published var isSpeaking = false

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func leerCuento(texto: String) {
        // Configuramos lo que va a decir
        let utterance = AVSpeechUtterance(string: texto)
        
        // Configuramos el idioma (Español de México)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        
        // Velocidad un poco más lenta (0.5 es normal, 0.4 es mejor para niños)
        utterance.rate = 0.4
        
        // ¡Hablar!
        synthesizer.speak(utterance)
        isSpeaking = true
    }

    func detener() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        isSpeaking = false
    }

    // Esta función avisa cuando la IA termina de hablar por sí sola
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}
