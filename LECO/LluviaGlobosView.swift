import SwiftUI
import Combine

// --- Estructura de un Globo ---
struct Globo: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let texto: String
    let esVocal: Bool
    let color: Color
    let velocidad: CGFloat
}

struct LluviaGlobosView: View {
    @Environment(\.dismiss) var dismiss
    
    // --- Configuración ---
    let vocales = ["A", "E", "I", "O", "U"]
    let letrasExtra = ["B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "R", "S", "T"]
    let colores: [Color] = [.red, .blue, .green, .orange, .purple, .pink]
    
    // --- Variables de Estado ---
    @State private var globos: [Globo] = []
    @State private var score = 0
    @State private var timeRemaining = 60
    @State private var isGameOver = false
    @State private var mensajeGameOver = "¡Tiempo Terminado!"
    
    // --- Variable para mostrar la hoja educativa ---
    @State private var showInfoVocales = false
    
    // --- Temporizadores ---
    @State private var gameLoop = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State private var spawnTimer = Timer.publish(every: 0.7, on: .main, in: .common).autoconnect()
    @State private var clockTimer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // --- FONDO ---
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.cyan.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // --- DECORACIONES ---
                Image(systemName: "cloud.fill")
                    .font(.system(size: 150))
                    .foregroundColor(.white.opacity(0.4))
                    .position(x: 100, y: 100)
                
                Image(systemName: "cloud.fill")
                    .font(.system(size: 200))
                    .foregroundColor(.white.opacity(0.3))
                    .position(x: geo.size.width - 150, y: 200)
                
                Image(systemName: "cloud.fill")
                    .font(.system(size: 120))
                    .foregroundColor(.white.opacity(0.5))
                    .position(x: geo.size.width / 2, y: 50)
                
                // --- GLOBOS ---
                ForEach(globos) { globo in
                    dibujarGlobo(globo)
                        .position(x: globo.x, y: globo.y)
                        .onTapGesture {
                            reventarGlobo(globo)
                        }
                }
                
                // --- HUD ---
                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Label("Volver", systemImage: "arrowshape.turn.up.left.fill")
                                .font(.title3)
                                .padding(12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(15)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("Tiempo: \(timeRemaining)")
                            Text("Puntos: \(score)")
                        }
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(15)
                    }
                    .padding()
                    
                    Spacer()
                    
                    if !isGameOver {
                        Text("¡No dejes escapar las VOCALES!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                            .padding(.bottom, 20)
                    }
                }
                
                // --- PANTALLA DE GAME OVER ---
                if isGameOver {
                    ZStack {
                        Color.black.opacity(0.6).ignoresSafeArea()
                        
                        VStack(spacing: 25) {
                            Text(mensajeGameOver)
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Text("Puntos Totales: \(score)")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            
                            // BOTÓN JUGAR DE NUEVO
                            Button("Jugar de Nuevo") {
                                reiniciarJuego()
                            }
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(20)
                            .frame(width: 300)
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .cornerRadius(30)
                            
                            // --- BOTÓN EDUCATIVO ---
                            Button(action: {
                                showInfoVocales = true
                            }) {
                                HStack {
                                    Image(systemName: "book.fill")
                                    Text("Aprender Vocales")
                                }
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(20)
                                .frame(width: 300)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(30)
                            }
                        }
                    }
                }
            }
            // --- AQUÍ SE CONECTA LA HOJA EDUCATIVA ---
            .sheet(isPresented: $showInfoVocales) {
                InfoVocalesView()
            }
            // --- TIMERS ---
            .onReceive(gameLoop) { _ in if !isGameOver { moverGlobos() } }
            .onReceive(spawnTimer) { _ in if !isGameOver { crearNuevoGlobo(anchoPantalla: geo.size.width, altoPantalla: geo.size.height) } }
            .onReceive(clockTimer) { _ in if timeRemaining > 0 && !isGameOver { timeRemaining -= 1 } else if timeRemaining == 0 { mensajeGameOver = "¡Tiempo Terminado!"; isGameOver = true } }
        }
        .navigationBarHidden(true)
    }
    
    // --- VISTA DE GLOBO ---
    func dibujarGlobo(_ globo: Globo) -> some View {
        ZStack {
            Rectangle().fill(Color.white.opacity(0.5)).frame(width: 2, height: 40).offset(y: 65)
            Circle().fill(globo.color).frame(width: 110, height: 110).shadow(radius: 5)
            Circle().fill(Color.white.opacity(0.3)).frame(width: 30, height: 30).offset(x: -25, y: -25)
            Text(globo.texto).font(.system(size: 50, weight: .bold)).foregroundColor(.white).shadow(radius: 2)
        }
    }
    
    // --- LÓGICA ---
    func crearNuevoGlobo(anchoPantalla: CGFloat, altoPantalla: CGFloat) {
        var probabilidadVocal = 0.6
        var velocidadMin: CGFloat = 7.0
        var velocidadMax: CGFloat = 10.0
        
        if score >= 20 {
            probabilidadVocal = 0.35
            velocidadMin = 18.0
            velocidadMax = 25.0
        } else if score >= 10 {
            probabilidadVocal = 0.5
            velocidadMin = 12.0
            velocidadMax = 16.0
        }
        
        let generarVocal = Double.random(in: 0...1) < probabilidadVocal
        let texto = generarVocal ? vocales.randomElement()! : letrasExtra.randomElement()!
        let color = colores.randomElement()!
        let xPos = CGFloat.random(in: 80...(anchoPantalla - 80))
        let velocidad = CGFloat.random(in: velocidadMin...velocidadMax)
        
        let nuevoGlobo = Globo(x: xPos, y: altoPantalla + 120, texto: texto, esVocal: generarVocal, color: color, velocidad: velocidad)
        globos.append(nuevoGlobo)
    }
    
    func moverGlobos() {
        for i in globos.indices {
            globos[i].y -= globos[i].velocidad
        }
        globos.removeAll { globo in
            if globo.y < -150 {
                if globo.esVocal {
                    mensajeGameOver = "¡Se escapó la vocal '\(globo.texto)'!"
                    isGameOver = true
                }
                return true
            }
            return false
        }
    }
    
    func reventarGlobo(_ globo: Globo) {
        if isGameOver { return }
        if globo.esVocal {
            score += 1
            if let index = globos.firstIndex(where: { $0.id == globo.id }) { globos.remove(at: index) }
        } else {
            mensajeGameOver = "¡Ups! '\(globo.texto)' no es vocal"
            isGameOver = true
        }
    }
    
    func reiniciarJuego() {
        globos.removeAll()
        score = 0
        timeRemaining = 60
        isGameOver = false
        mensajeGameOver = "¡Tiempo Terminado!"
    }
}

struct LluviaGlobosView_Previews: PreviewProvider {
    static var previews: some View {
        LluviaGlobosView()
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
