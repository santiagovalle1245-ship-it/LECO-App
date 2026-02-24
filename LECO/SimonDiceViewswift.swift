import SwiftUI

struct SimonDiceView: View {
    @Environment(\.dismiss) var dismiss
    
    // --- 1. Configuración de Colores ---
    // Definimos los 4 colores del juego y sus posiciones
    enum SimonColor: Int, CaseIterable {
        case rojo = 0
        case verde = 1
        case azul = 2
        case amarillo = 3
        
        var color: Color {
            switch self {
            case .rojo: return Color(red: 1.0, green: 0.3, blue: 0.3)
            case .verde: return Color(red: 0.3, green: 0.8, blue: 0.3)
            case .azul: return Color(red: 0.3, green: 0.5, blue: 1.0)
            case .amarillo: return Color(red: 1.0, green: 0.8, blue: 0.0)
            }
        }
        
        var icono: String {
            switch self {
            case .rojo: return "star.fill"
            case .verde: return "leaf.fill"
            case .azul: return "drop.fill"
            case .amarillo: return "sun.max.fill"
            }
        }
    }
    
    // --- 2. Variables del Juego ---
    @State private var sequence: [SimonColor] = []     // La secuencia correcta
    @State private var userStep = 0                    // En qué paso va el usuario
    @State private var isCPUTurn = false               // ¿Está jugando la compu?
    @State private var message = "¡Toca 'Iniciar'!"    // Mensaje central
    @State private var score = 0
    @State private var litButton: SimonColor? = nil    // Qué botón está "encendido"
    @State private var gameEnded = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // --- FONDO OSCURO (Estilo Espacial/Arcade) ---
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.1, green: 0.1, blue: 0.2),
                        Color(red: 0.2, green: 0.1, blue: 0.3)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // --- Decoraciones de fondo ---
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 50)
                    .frame(width: 600, height: 600)
                
                Image(systemName: "music.note")
                    .font(.system(size: 150))
                    .foregroundColor(.white.opacity(0.05))
                    .position(x: 100, y: 100)
                    .rotationEffect(.degrees(-20))
                
                // --- CONTENIDO ---
                VStack(spacing: 30) {
                    
                    // Encabezado
                    HStack {
                        Button(action: { dismiss() }) {
                            Label("Volver", systemImage: "arrowshape.turn.up.left.fill")
                                .font(.title3)
                                .padding(12)
                                .background(Color.white.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                        Spacer()
                        Text("Ronda: \(score)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding([.horizontal, .top], 40)
                    
                    // Mensaje de Instrucción
                    Text(message)
                        .font(.system(size: 40, weight: .bold)) // Texto muy grande
                        .foregroundColor(.white)
                        .shadow(color: .purple, radius: 10)
                        .padding(.vertical, 20)
                        .multilineTextAlignment(.center)
                    
                    // --- EL TABLERO DE JUEGO (2x2) ---
                    if !gameEnded {
                        VStack(spacing: 20) {
                            // Fila Superior
                            HStack(spacing: 20) {
                                SimonButton(simonColor: .verde, litButton: $litButton) {
                                    playerTap(color: .verde)
                                }
                                SimonButton(simonColor: .rojo, litButton: $litButton) {
                                    playerTap(color: .rojo)
                                }
                            }
                            
                            // Fila Inferior
                            HStack(spacing: 20) {
                                SimonButton(simonColor: .amarillo, litButton: $litButton) {
                                    playerTap(color: .amarillo)
                                }
                                SimonButton(simonColor: .azul, litButton: $litButton) {
                                    playerTap(color: .azul)
                                }
                            }
                        }
                        .disabled(isCPUTurn) // Desactiva los botones si es turno de la CPU
                        .padding(20)
                        
                        // Botón de Iniciar (Solo visible al principio)
                        if sequence.isEmpty {
                            Button("▶️ Iniciar Juego") {
                                startNewGame()
                            }
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(25)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(30)
                            .shadow(radius: 10)
                            .padding(.top, 20)
                        }
                        
                    } else {
                        // --- PANTALLA DE GAME OVER ---
                        VStack(spacing: 30) {
                            Text("¡Juego Terminado! 💥")
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(.red)
                            
                            Text("Llegaste a la ronda \(score)")
                                .font(.title)
                                .foregroundColor(.white)
                            
                            Button("Intentar de Nuevo") {
                                startNewGame()
                            }
                            .font(.title)
                            .padding(25)
                            .background(Color.white)
                            .cornerRadius(30)
                        }
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(20)
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // --- LÓGICA DEL JUEGO ---
    
    func startNewGame() {
        sequence = []
        score = 0
        gameEnded = false
        addToSequence()
    }
    
    func addToSequence() {
        // 1. Añadimos un color aleatorio
        let randomColor = SimonColor.allCases.randomElement()!
        sequence.append(randomColor)
        
        // 2. Preparamos el turno de la CPU
        userStep = 0
        score = sequence.count
        playSequence()
    }
    
    func playSequence() {
        isCPUTurn = true
        message = "👁️ ¡Observa!"
        
        // Reproducimos la secuencia con pausas
        for (index, color) in sequence.enumerated() {
            let delay = 1.0 + (Double(index) * 0.8) // Calculamos el tiempo de cada destello
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                flashButton(color: color)
            }
        }
        
        // Devolvemos el control al jugador cuando termine
        let totalDelay = 1.0 + (Double(sequence.count) * 0.8)
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay) {
            isCPUTurn = false
            message = "🫵 ¡Tu turno!"
        }
    }
    
    func flashButton(color: SimonColor) {
        // Encendemos el botón
        litButton = color
        
        // Lo apagamos después de 0.4 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            litButton = nil
        }
    }
    
    func playerTap(color: SimonColor) {
        if isCPUTurn { return } // Seguridad
        
        // Iluminamos brevemente al tocar
        flashButton(color: color)
        
        // Verificamos si es correcto
        if color == sequence[userStep] {
            userStep += 1
            
            // ¿Terminó la secuencia actual?
            if userStep == sequence.count {
                isCPUTurn = true
                message = "¡Bien hecho! 👏"
                // Pequeña pausa antes de la siguiente ronda
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    addToSequence()
                }
            }
        } else {
            // Se equivocó
            gameEnded = true
        }
    }
}

// --- VISTA DEL BOTÓN PERSONALIZADO ---
struct SimonButton: View {
    let simonColor: SimonDiceView.SimonColor
    @Binding var litButton: SimonDiceView.SimonColor?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(simonColor.color)
                
                // Icono decorativo
                Image(systemName: simonColor.icono)
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.5))
            }
            .frame(height: 200) // Botones grandes para iPad
            // Si este botón está "encendido" (litButton), brilla al 100%, si no, se ve más oscuro (0.4)
            .opacity(litButton == simonColor ? 1.0 : 0.4)
            .scaleEffect(litButton == simonColor ? 1.05 : 1.0) // Efecto de "pop"
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: litButton == simonColor ? 5 : 0)
            )
            .shadow(color: simonColor.color, radius: litButton == simonColor ? 20 : 0)
        }
    }
}

struct SimonDiceView_Previews: PreviewProvider {
    static var previews: some View {
        SimonDiceView()
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
