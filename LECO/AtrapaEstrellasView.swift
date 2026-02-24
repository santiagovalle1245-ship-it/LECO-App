import SwiftUI
import Combine

struct AtrapaEstrellasView: View {
    @Environment(\.dismiss) var dismiss
    
    // --- Estructura de los objetos ---
    struct ObjetoCayendo: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        let esBueno: Bool // True = Estrella, False = Meteoro
        let velocidad: CGFloat
    }
    
    // --- Variables del Juego ---
    @State private var posicionJugador: CGFloat = 0
    @State private var objetos: [ObjetoCayendo] = []
    @State private var score = 0
    @State private var vidas = 3
    @State private var estrellasPerdidas = 0
    @State private var isGameOver = false
    @State private var mensajeGameOver = ""
    
    // --- Temporizadores ---
    @State private var gameLoop = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    @State private var spawnTimer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // --- 1. FONDO ---
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.3), Color(red: 0.2, green: 0.2, blue: 0.5)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Decoraciones
                Image(systemName: "sparkles")
                    .font(.system(size: 150))
                    .foregroundColor(.white.opacity(0.1))
                    .position(x: 150, y: 250)
                
                // --- 2. JUGADOR ---
                Image("personaje_juego")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .position(x: posicionJugador, y: geo.size.height - 100)
                    .shadow(color: .black.opacity(0.5), radius: 10)
                
                // --- 3. OBJETOS QUE CAEN ---
                ForEach(objetos) { objeto in
                    Image(objeto.esBueno ? "estrella_juego" : "meteoro_juego")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .position(x: objeto.x, y: objeto.y)
                        .shadow(radius: 5)
                }
                
                // --- 4. HUD (Marcador) ---
                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Label("Salir", systemImage: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        // Vidas
                        HStack(spacing: 5) {
                            Image(systemName: "heart.fill").foregroundColor(.red)
                            Text("\(vidas)")
                        }
                        .font(.title2)
                        .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Estrellas Perdidas
                        HStack(spacing: 5) {
                            Image(systemName: "star.slash.fill").foregroundColor(.orange)
                            Text("\(estrellasPerdidas)/3")
                        }
                        .font(.title2)
                        .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Puntos: \(score)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                    }
                    .padding()
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(15)
                    .padding(.top, 40)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .zIndex(1) // HUD siempre visible
                
                // --- 5. PANTALLA DE GAME OVER (Z-INDEX ALTO) ---
                if isGameOver {
                    ZStack {
                        Color.black.opacity(0.85).ignoresSafeArea()
                        
                        VStack(spacing: 30) {
                            Text(mensajeGameOver)
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Text("Puntaje Final: \(score)")
                                .font(.largeTitle)
                                .foregroundColor(.yellow)
                            
                            // BOTÓN DE REINICIO
                            Button(action: {
                                reiniciarJuego()
                            }) {
                                Text("Jugar de Nuevo")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(25)
                                    .background(Color.white)
                                    .foregroundColor(.blue)
                                    .cornerRadius(30)
                                    .shadow(radius: 10)
                            }
                        }
                    }
                    .zIndex(10) // ¡IMPORTANTE! Esto asegura que esté encima de todo y reciba el click
                    .transition(.opacity)
                }
                
                // --- 6. CONTROL TÁCTIL ---
                // Lo ponemos al fondo del ZStack (pero sobre el color) para que no tape el botón de Game Over
                Color.white.opacity(0.001)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if !isGameOver {
                                    posicionJugador = value.location.x
                                }
                            }
                    )
                    .zIndex(0)
            }
            .onAppear {
                posicionJugador = geo.size.width / 2
            }
            .onReceive(gameLoop) { _ in
                if !isGameOver {
                    actualizarJuego(altoPantalla: geo.size.height)
                }
            }
            .onReceive(spawnTimer) { _ in
                if !isGameOver {
                    generarObjeto(anchoPantalla: geo.size.width)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // --- LÓGICA DEL JUEGO ---
    
    func generarObjeto(anchoPantalla: CGFloat) {
        // Dificultad progresiva
        var probabilidadEstrella = 0.5
        if score >= 1000 { probabilidadEstrella = 0.2 }
        else if score >= 750 { probabilidadEstrella = 0.3 }
        else if score >= 500 { probabilidadEstrella = 0.4 }
        
        let esBueno = Double.random(in: 0...1) < probabilidadEstrella
        
        // Velocidad progresiva
        let puntosParaSubirNivel: CGFloat = 50.0
        let bonoVelocidad = CGFloat(score) / puntosParaSubirNivel
        let velocidadMin = min(4.0 + bonoVelocidad, 15.0)
        let velocidadMax = min(8.0 + bonoVelocidad, 20.0)
        
        let nuevoObjeto = ObjetoCayendo(
            x: CGFloat.random(in: 60...(anchoPantalla - 60)),
            y: -100,
            esBueno: esBueno,
            velocidad: CGFloat.random(in: velocidadMin...velocidadMax)
        )
        objetos.append(nuevoObjeto)
    }
    
    func actualizarJuego(altoPantalla: CGFloat) {
        for i in objetos.indices {
            objetos[i].y += objetos[i].velocidad
        }
        
        var indicesAEliminar: [Int] = []
        
        for i in objetos.indices {
            let obj = objetos[i]
            
            let distanciaX = abs(obj.x - posicionJugador)
            let distanciaY = abs(obj.y - (altoPantalla - 100))
            
            // Colisión
            if distanciaX < 90 && distanciaY < 90 {
                if obj.esBueno {
                    score += 10
                } else {
                    vidas -= 1
                    if vidas <= 0 {
                        mensajeGameOver = "¡Te golpeó un meteoro!"
                        isGameOver = true
                    }
                }
                indicesAEliminar.append(i)
            }
            // Salió de la pantalla
            else if obj.y > altoPantalla + 100 {
                if obj.esBueno {
                    estrellasPerdidas += 1
                    if estrellasPerdidas >= 3 {
                        mensajeGameOver = "¡Se escaparon 3 estrellas!"
                        isGameOver = true
                    }
                }
                indicesAEliminar.append(i)
            }
        }
        
        for index in indicesAEliminar.reversed() {
            objetos.remove(at: index)
        }
    }
    
    func reiniciarJuego() {
        // Reseteo manual de todas las variables
        score = 0
        vidas = 3
        estrellasPerdidas = 0
        objetos.removeAll() // Borra los meteoros que quedaron en pantalla
        isGameOver = false
    }
}

struct AtrapaEstrellasView_Previews: PreviewProvider {
    static var previews: some View {
        AtrapaEstrellasView()
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
