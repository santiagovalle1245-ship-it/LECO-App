import Foundation
import AVFoundation
import Combine

class SpeechManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    
    private let synthesizer = AVSpeechSynthesizer()
    @Published var isSpeaking = false
    
    // --- NUESTROS DOS RADIOS PARA EL KARAOKE ---
    @Published var indicePalabraActual: Int = -1
    @Published var indiceRenglonActual: Int = -1 // ¡NUEVO! Avisa en qué renglón vamos
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func leerCuento(texto: String) {
        let utterance = AVSpeechUtterance(string: texto)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = 0.4
        
        // Apagamos los dos radios al empezar
        indicePalabraActual = -1
        indiceRenglonActual = -1
        
        synthesizer.speak(utterance)
        isSpeaking = true
    }
    
    func detener() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        isSpeaking = false
        indicePalabraActual = -1
        indiceRenglonActual = -1
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
        // 1. Calculamos la palabra actual (esto ya lo teníamos)
        let textoHastaAhora = String(utterance.speechString.prefix(characterRange.location))
        let palabrasAnteriores = textoHastaAhora.split(separator: " ")
        
        // 2. NUEVO: Calculamos el renglón actual usando los puntos finales (".")
        // Cortamos el texto hasta donde vamos usando el punto como separador
        let renglonesAnteriores = textoHastaAhora.split(separator: ".")
        
        DispatchQueue.main.async {
            self.indicePalabraActual = palabrasAnteriores.count
            
            // Si no ha habido ningún punto, estamos en el renglón 0.
            // Si ya pasó un punto, estamos en el renglón 1, etc.
            self.indiceRenglonActual = max(0, renglonesAnteriores.count - 1)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.indicePalabraActual = -1
            self.indiceRenglonActual = -1
        }
    }
}
