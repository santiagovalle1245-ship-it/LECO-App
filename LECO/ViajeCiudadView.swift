import SwiftUI
import Combine

struct ViajeCiudadView: View {
    @Environment(\.dismiss) var dismiss
    
    // --- Estructura de los objetos ---
    struct ObjetoJuego: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        let esBueno: Bool
        let nombreImagen: String
        let tamaño: CGFloat = 70
        
        // Velocidad en dos direcciones
        let velocidadX: CGFloat
        let velocidadY: CGFloat
    }
    
    // --- Variables del Juego ---
    @State private var personajeY: CGFloat = 0
    @State private var objetos: [ObjetoJuego] = []
    @State private var score = 0
    @State private var isGameOver = false
    @State private var gameStarted = false
    @State private var isTouching = false
    
    // --- Física del Personaje ---
    let gravedad: CGFloat = 1.5       // Cae rápido (Recto)
    let fuerzaMotor: CGFloat = -1.5   // Sube rápido (Recto)
    
    // --- Temporizadores ---
    @State private var gameLoop = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    @State private var spawnTimer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // --- 1. FONDO ---
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.1, green: 0.0, blue: 0.3),
                        Color(red: 0.3, green: 0.1, blue: 0.4)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // --- Decoraciones ---
                Image(systemName: "building.2.crop.circle.fill")
                    .font(.system(size: 300))
                    .foregroundColor(.white.opacity(0.05))
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                
                ForEach(0..<5) { i in
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 5, height: 5)
                        .position(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: CGFloat.random(in: 0...geo.size.height)
                        )
                }
                
                // --- 2. OBJETOS ---
                ForEach(objetos) { objeto in
                    Image(objeto.nombreImagen)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(
                            Group {
                                if UIImage(named: objeto.nombreImagen) == nil {
                                    Image(systemName: objeto.esBueno ? "star.fill" : "meteor")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(objeto.esBueno ? .yellow : .gray)
                                }
                            }
                        )
                        .frame(width: objeto.tamaño, height: objeto.tamaño)
                        .position(x: objeto.x, y: objeto.y)
                        .shadow(color: objeto.esBueno ? .yellow : .red, radius: 5)
                }
                
                // --- 3. PERSONAJE (CENTRADO) ---
                Image("personaje_flappy")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Group {
                            if UIImage(named: "personaje_flappy") == nil {
                                Image(systemName: "airplane.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                            }
                        }
                    )
                    .frame(width: 100, height: 100)
                    .position(x: geo.size.width / 2, y: personajeY)
                    .shadow(color: .cyan, radius: 10)
                
                // --- 4. HUD ---
                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Label("Salir", systemImage: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Text("Puntos: \(score)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    .padding(.horizontal)
                    Spacer()
                }
                
                // --- 5. MENSAJES ---
                if !gameStarted && !isGameOver {
                    VStack {
                        Text("Vuelo Nocturno")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Mantén para subir\nSuelta para bajar")
                            .font(.title2)
                            .foregroundColor(.cyan)
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(20)
                    }
                }
                
                if isGameOver {
                    ZStack {
                        Color.black.opacity(0.7).ignoresSafeArea()
                        VStack(spacing: 20) {
                            Text("¡Impacto!")
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Puntaje: \(score)")
                                .font(.title)
                                .foregroundColor(.yellow)
                            
                            Button("Reintentar") {
                                reiniciarJuego(altoPantalla: geo.size.height)
                            }
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(25)
                            .background(Color.white)
                            .cornerRadius(30)
                        }
                    }
                }
                
                // --- 6. CONTROL ---
                Color.white.opacity(0.001)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                if !isGameOver {
                                    if !gameStarted { gameStarted = true }
                                    isTouching = true
                                }
                            }
                            .onEnded { _ in
                                isTouching = false
                            }
                    )
            }
            .onAppear {
                personajeY = geo.size.height / 2
            }
            .onReceive(gameLoop) { _ in
                if gameStarted && !isGameOver {
                    actualizarJuego(altoPantalla: geo.size.height, anchoPantalla: geo.size.width)
                }
            }
            .onReceive(spawnTimer) { _ in
                if gameStarted && !isGameOver {
                    generarObjeto(anchoPantalla: geo.size.width, altoPantalla: geo.size.height)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // --- LÓGICA ---
    
    func generarObjeto(anchoPantalla: CGFloat, altoPantalla: CGFloat) {
        
        // --- [EDITABLE] LÓGICA DE PROBABILIDAD ---
        var chanceBueno = 0.5 // 50% Bueno al inicio
        
        if score >= 50 {
            chanceBueno = 0.2 // 20% Bueno (Muy difícil)
        } else if score >= 25 {
            chanceBueno = 0.35 // 35% Bueno (Más difícil)
        }
        
        let esBueno = Double.random(in: 0...1) < chanceBueno
        
        var nombreFinal = ""
        if esBueno {
            nombreFinal = "premio_ciudad"
        } else {
            nombreFinal = Bool.random() ? "obstaculo_ciudad1" : "obstaculo_ciudad2"
        }
        
        // Esquinas
        let saleDeArriba = Bool.random()
        let startY: CGFloat = saleDeArriba ? 50 : altoPantalla - 50
        
        // LÓGICA DE VELOCIDAD 
        var velocidadMinX: CGFloat = 6.0
        var velocidadMaxX: CGFloat = 10.0
        
        if score >= 15 {
            // Aumentamos la velocidad base un poco por cada punto extra
            let factor = CGFloat(score - 15) * 0.2
            velocidadMinX += factor
            velocidadMaxX += factor
        }
        
        // Tope máximo de velocidad para que no sea imposible
        if velocidadMinX > 15.0 { velocidadMinX = 15.0 }
        if velocidadMaxX > 20.0 { velocidadMaxX = 20.0 }
        
        let velocidadVertical = saleDeArriba ? CGFloat.random(in: 1...4) : CGFloat.random(in: -4...(-1))
        
        let nuevoObjeto = ObjetoJuego(
            x: anchoPantalla + 50,
            y: startY,
            esBueno: esBueno,
            nombreImagen: nombreFinal,
            velocidadX: CGFloat.random(in: velocidadMinX...velocidadMaxX), // Velocidad dinámica
            velocidadY: velocidadVertical
        )
        
        objetos.append(nuevoObjeto)
    }
    
    func actualizarJuego(altoPantalla: CGFloat, anchoPantalla: CGFloat) {
        // Movimiento Personaje (Recto)
        if isTouching {
            personajeY -= 10
        } else {
            personajeY += 10
        }
        
        if personajeY < 50 { personajeY = 50 }
        if personajeY > altoPantalla - 50 { personajeY = altoPantalla - 50 }
        
        // Movimiento Objetos
        for i in objetos.indices {
            objetos[i].x -= objetos[i].velocidadX
            objetos[i].y += objetos[i].velocidadY
        }
        
        // Colisiones
        var indicesAEliminar: [Int] = []
        let playerXPosition = anchoPantalla / 2
        
        for i in objetos.indices {
            let obj = objetos[i]
            
            let distanciaX = abs(obj.x - playerXPosition)
            let distanciaY = abs(obj.y - personajeY)
            
            if distanciaX < 60 && distanciaY < 60 {
                if obj.esBueno {
                    score += 1
                } else {
                    isGameOver = true
                }
                indicesAEliminar.append(i)
            }
            else if obj.x < -50 {
                indicesAEliminar.append(i)
            }
        }
        
        for index in indicesAEliminar.reversed() {
            objetos.remove(at: index)
        }
    }
    
    func reiniciarJuego(altoPantalla: CGFloat) {
        score = 0
        objetos.removeAll()
        personajeY = altoPantalla / 2
        isGameOver = false
        gameStarted = false
        isTouching = false
    }
}

struct ViajeCiudadView_Previews: PreviewProvider {
    static var previews: some View {
        ViajeCiudadView()
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
