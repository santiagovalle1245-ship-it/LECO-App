import SwiftUI

struct PruebaCuentoView: View {
    @Environment(\.dismiss) var dismiss
    let cuento: Cuento
    
    @State private var indexPregunta = 0
    @State private var score = 0
    @State private var showFeedback = false
    @State private var feedbackMessage = ""
    @State private var feedbackColor = Color.clear
    @State private var quizTerminado = false
    
    var body: some View {
        ZStack {
            // Fondo azul relajante para la prueba
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.cyan.opacity(0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                if !quizTerminado {
                    // Título de la prueba
                    Text("Prueba de Lectura")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    Text("Pregunta \(indexPregunta + 1) de \(cuento.preguntas.count)")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    // La Pregunta Actual
                    Text(cuento.preguntas[indexPregunta].pregunta)
                        .font(.system(size: 35, weight: .bold)) // Letra grande
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(20)
                        .padding(.horizontal)
                    
                    // Opciones de Respuesta
                    VStack(spacing: 20) {
                        ForEach(cuento.preguntas[indexPregunta].opciones, id: \.self) { opcion in
                            Button(action: {
                                checkRespuesta(opcion)
                            }) {
                                Text(opcion)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .shadow(radius: 3)
                            }
                        }
                    }
                    .padding(.horizontal, 50)
                    
                    // Feedback Visual
                    if showFeedback {
                        Text(feedbackMessage)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(feedbackColor)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(15)
                            .transition(.scale)
                    }
                    
                    Spacer()
                    
                } else {
                    // Pantalla Final
                    VStack(spacing: 30) {
                        Text("¡Prueba Completada!")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Aciertos: \(score) de \(cuento.preguntas.count)")
                            .font(.title)
                            .foregroundColor(.white)
                        
                        if score == cuento.preguntas.count {
                            Text("🌟 ¡Excelente trabajo! 🌟")
                                .font(.title)
                                .foregroundColor(.yellow)
                        } else {
                            Text("¡Sigue practicando!")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        Button("Volver al Cuento") {
                            dismiss()
                        }
                        .font(.title2)
                        .padding(20)
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(20)
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(30)
                }
            }
        }
    }
    
    func checkRespuesta(_ respuesta: String) {
        if showFeedback { return } // Evitar doble clic
        
        let correcta = cuento.preguntas[indexPregunta].respuestaCorrecta
        
        if respuesta == correcta {
            score += 1
            feedbackMessage = "¡Correcto! ✅"
            feedbackColor = .green
        } else {
            feedbackMessage = "Ups, era '\(correcta)' ❌"
            feedbackColor = .red
        }
        
        withAnimation { showFeedback = true }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showFeedback = false
            if indexPregunta < cuento.preguntas.count - 1 {
                indexPregunta += 1
            } else {
                quizTerminado = true
            }
        }
    }
}

struct PruebaCuentoView_Previews: PreviewProvider {
    static var previews: some View {
        PruebaCuentoView(cuento: listaDeCuentos[0])
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
