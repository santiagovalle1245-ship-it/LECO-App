import SwiftUI

struct PalabraPerdidaView: View {
    @Environment(\.dismiss) var dismiss
    
    // --- Estructura de Datos ---
    struct Question {
        let sentence: String
        let missingWord: String
        let options: [String]
    }

    // Tus oraciones
    let questions: [Question] = [
        Question(sentence: "El ____ corre en el parque.", missingWord: "perro", options: ["perro", "vuela", "nada"]),
        Question(sentence: "Me gusta comer ____ en la mañana.", missingWord: "pan", options: ["pan", "piedras", "hojas"]),
        Question(sentence: "El sol brilla en el ____.", missingWord: "cielo", options: ["cielo", "pasto", "agua"]),
        Question(sentence: "Mi hermano juega con una ____.", missingWord: "pelota", options: ["pelota", "manzana", "silla"]),
        Question(sentence: "La maestra escribe en el ____.", missingWord: "pizarrón", options: ["pizarrón", "plato", "camino"]),
        Question(sentence: "Voy a la escuela en ____.", missingWord: "camión", options: ["camión", "avión", "barco"]),
        Question(sentence: "El gato bebe ____.", missingWord: "leche", options: ["leche", "arena", "fuego"]),
        Question(sentence: "Los peces viven en el ____.", missingWord: "agua", options: ["agua", "aire", "bosque"]),
        Question(sentence: "El bebé duerme en su ____.", missingWord: "cuna", options: ["cuna", "silla", "caja"]),
        Question(sentence: "Mi mamá prepara sopa en la ____.", missingWord: "olla", options: ["olla", "tele", "cama"])
    ]
    
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var feedbackMessage = ""
    @State private var feedbackColor = Color.clear
    @State private var showFeedback = false
    @State private var gameEnded = false
    
    // Variable para mezclar las opciones
    @State private var currentOptions: [String] = []
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // --- FONDO VERDE / CIAN (El original) ---
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.2, green: 0.7, blue: 0.7), // Cian
                        Color(red: 0.1, green: 0.6, blue: 0.4)   // Verde
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // --- DECORACIONES SIMPLES (Sin imágenes) ---
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 300, height: 300)
                    .position(x: 100, y: 100)
                
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 400, height: 150)
                    .rotationEffect(.degrees(45))
                    .position(x: geo.size.width - 50, y: geo.size.height - 100)

                // --- CONTENIDO PRINCIPAL ---
                VStack {
                    // Botón de Volver (Arriba a la izquierda)
                    HStack {
                        Button(action: { dismiss() }) {
                            Label("Volver", systemImage: "arrowshape.turn.up.left.fill")
                                .font(.title3)
                                .padding(12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(15)
                                .shadow(radius: 3)
                        }
                        Spacer()
                    }
                    .padding([.leading, .top], 40)
                    
                    Spacer() // Empuja el contenido al centro
                    
                    // BLOQUE CENTRAL DEL JUEGO
                    VStack(spacing: 40) {
                        
                        Text("Palabra Perdida")
                            .font(.system(size: 70, weight: .bold)) // Título GIGANTE
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 5)
                        
                        if !gameEnded {
                            // Oración
                            Text(questions[currentQuestionIndex].sentence)
                                .font(.system(size: 45, weight: .medium)) // Letra MUY grande
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(30)
                                .background(Color.black.opacity(0.2))
                                .cornerRadius(20)
                                .padding(.horizontal, 40)
                            
                            // Opciones (Mezcladas)
                            HStack(spacing: 30) {
                                ForEach(currentOptions, id: \.self) { option in
                                    Button(action: {
                                        checkAnswer(option)
                                    }) {
                                        Text(option)
                                            .font(.system(size: 35, weight: .bold)) // Botones grandes
                                            .foregroundColor(Color(red: 0.1, green: 0.5, blue: 0.4))
                                            .padding(.vertical, 25)
                                            .padding(.horizontal, 40)
                                            .background(Color.white)
                                            .cornerRadius(25)
                                            .shadow(radius: 5, y: 5)
                                    }
                                }
                            }
                            
                            // Feedback
                            if showFeedback {
                                Text(feedbackMessage)
                                    .font(.largeTitle) // Feedback grande
                                    .fontWeight(.bold)
                                    .foregroundColor(feedbackColor)
                                    .padding(20)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(20)
                                    .transition(.scale)
                            }
                            
                            Text("Puntos: \(score) / \(questions.count)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.top, 10)
                            
                        } else {
                            // Pantalla Final
                            VStack(spacing: 30) {
                                Text("¡Juego Terminado!")
                                    .font(.system(size: 60, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Puntaje Final: \(score) / \(questions.count)")
                                    .font(.largeTitle)
                                    .foregroundColor(.white.opacity(0.9))
                                
                                Button("Jugar de Nuevo") {
                                    reiniciarJuego()
                                }
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(30)
                                .background(Color.white)
                                .foregroundColor(Color(red: 0.1, green: 0.6, blue: 0.4))
                                .cornerRadius(30)
                                .shadow(radius: 5)
                            }
                        }
                    }
                    
                    Spacer() // Empuja el contenido al centro desde abajo
                    Spacer() // Doble spacer para subirlo un poquito visualmente
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            mezclarOpciones()
        }
    }
    
    func mezclarOpciones() {
        currentOptions = questions[currentQuestionIndex].options.shuffled()
    }
    
    func checkAnswer(_ selectedAnswer: String) {
        if showFeedback { return }
        
        if selectedAnswer == questions[currentQuestionIndex].missingWord {
            feedbackMessage = "¡Correcto! ✅"
            feedbackColor = .green
            score += 1
        } else {
            feedbackMessage = "Incorrecto. Era '\(questions[currentQuestionIndex].missingWord)'."
            feedbackColor = .red
        }
        
        withAnimation {
            showFeedback = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showFeedback = false
            }
            if self.currentQuestionIndex < self.questions.count - 1 {
                self.currentQuestionIndex += 1
                self.mezclarOpciones()
            } else {
                self.gameEnded = true
            }
        }
    }
    
    func reiniciarJuego() {
        currentQuestionIndex = 0
        score = 0
        gameEnded = false
        showFeedback = false
        mezclarOpciones()
    }
}

struct PalabraPerdidaView_Previews: PreviewProvider {
    static var previews: some View {
        PalabraPerdidaView()
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
