import SwiftUI
import Combine

struct CarreraView: View {
    @Environment(\.dismiss) var dismiss
    
    // --- Estructura de los objetos de la carretera ---
    struct ObjetoCarretera: Identifiable {
        let id = UUID()
        let carril: Int // 0, 1, o 2
        var y: CGFloat  // Posición vertical
        let esBueno: Bool // True = Moneda, False = Obstáculo
    }
    
    // --- Variables del Juego ---
    @State private var carrilJugador = 1 // Empieza en el centro (0, 1, 2)
    @State private var objetos: [ObjetoCarretera] = []
    @State private var score = 0
    @State private var vidas = 3
    @State private var isGameOver = false
    
    // --- Configuración de Velocidad ---
    @State private var velocidadBase: CGFloat = 8.0
    
    // --- Temporizadores ---
    // Loop del juego (movimiento fluido)
    @State private var gameLoop = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    // Generador de obstáculos (ajustable)
    @State private var spawnTimer = Timer.publish(every: 0.8, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            let anchoCarril = geo.size.width / 3
            
            ZStack {
                // --- 1. FONDO (Césped a los lados) ---
                Color.green.opacity(0.6).ignoresSafeArea()
                
                // --- 2. LA CARRETERA ---
                ZStack {
                    Color.gray // Asfalto
                    
                    // Líneas divisorias blancas
                    HStack(spacing: 0) {
                        Spacer()
                        Rectangle().fill(Color.white).frame(width: 5).opacity(0.5)
                        Spacer()
                        Rectangle().fill(Color.white).frame(width: 5).opacity(0.5)
                        Spacer()
                    }
                }
                .frame(width: geo.size.width) // Ocupa todo el ancho en este diseño simple
                
                // --- 3. OBJETOS QUE VIENEN ---
                ForEach(objetos) { objeto in
                    // Calculamos la posición X basada en el carril (0, 1, 2)
                    let posX = (CGFloat(objeto.carril) * anchoCarril) + (anchoCarril / 2)
                    
                    Image(objeto.esBueno ? "moneda" : "obstaculo") // Usa tus imágenes
                        // Si no hay imagen, usa SF Symbols como respaldo:
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(
                            Group {
                                if UIImage(named: objeto.esBueno ? "moneda" : "obstaculo") == nil {
                                    Image(systemName: objeto.esBueno ? "centsign.circle.fill" : "cone.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(objeto.esBueno ? .yellow : .orange)
                                }
                            }
                        )
                        .frame(width: 100, height: 100) // Tamaño grande para iPad
                        .position(x: posX, y: objeto.y)
                        .shadow(radius: 5)
                }
                
                // --- 4. JUGADOR (Coche) ---
                let playerX = (CGFloat(carrilJugador) * anchoCarril) + (anchoCarril / 2)
                
                Image("coche_jugador") // Tu imagen
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Group {
                            if UIImage(named: "coche_jugador") == nil {
                                Image(systemName: "car.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.blue)
                            }
                        }
                    )
                    .frame(width: 140, height: 140) // Coche grande
                    .position(x: playerX, y: geo.size.height - 150)
                    .shadow(radius: 10)
                    .animation(.spring(), value: carrilJugador) // Movimiento suave al cambiar carril
                
                
                // --- 5. CONTROLES INVISIBLES (Toque Izq / Der) ---
                HStack(spacing: 0) {
                    // Zona Izquierda
                    Color.white.opacity(0.001)
                        .onTapGesture {
                            moverIzquierda()
                        }
                    // Zona Derecha
                    Color.white.opacity(0.001)
                        .onTapGesture {
                            moverDerecha()
                        }
                }
                
                // --- 6. HUD (Marcador) ---
                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Label("Salir", systemImage: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .cornerRadius(15)
                        }
                        Spacer()
                        
                        // Vidas
                        HStack {
                            ForEach(0..<3, id: \.self) { index in
                                Image(systemName: index < vidas ? "heart.fill" : "heart")
                                    .foregroundColor(.red)
                                    .font(.largeTitle)
                            }
                        }
                        
                        Spacer()
                        
                        Text("Puntos: \(score)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(15)
                    }
                    .padding(.top, 40)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Guía visual de controles (opcional)
                    if !isGameOver && score < 5 {
                        HStack {
                            Image(systemName: "hand.tap.fill")
                            Spacer()
                            Image(systemName: "hand.tap.fill")
                        }
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.horizontal, 80)
                        .padding(.bottom, 50)
                    }
                }
                
                // --- 7. PANTALLA GAME OVER ---
                if isGameOver {
                    ZStack {
                        Color.black.opacity(0.8).ignoresSafeArea()
                        VStack(spacing: 30) {
                            Text("¡Choque! 💥")
                                .font(.system(size: 70, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Puntos: \(score)")
                                .font(.largeTitle)
                                .foregroundColor(.yellow)
                            
                            Button("Correr de Nuevo") {
                                reiniciarJuego()
                            }
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(30)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                        }
                    }
                }
            }
            // --- Lógica de Timers ---
            .onReceive(gameLoop) { _ in
                if !isGameOver {
                    actualizarJuego(altoPantalla: geo.size.height)
                }
            }
            .onReceive(spawnTimer) { _ in
                if !isGameOver {
                    generarObjeto()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // --- FUNCIONES DE CONTROL ---
    func moverIzquierda() {
        if carrilJugador > 0 {
            carrilJugador -= 1
        }
    }
    
    func moverDerecha() {
        if carrilJugador < 2 {
            carrilJugador += 1
        }
    }
    
    // --- LÓGICA DEL JUEGO ---
    func generarObjeto() {
        // Elegir carril al azar (0, 1, 2)
        let carrilRandom = Int.random(in: 0...2)
        
        // Probabilidad: 60% Obstáculo, 40% Moneda (Más obstáculos es más divertido en carreras)
        let esBueno = Double.random(in: 0...1) > 0.6
        
        let nuevoObjeto = ObjetoCarretera(
            carril: carrilRandom,
            y: -100, // Empieza arriba
            esBueno: esBueno
        )
        objetos.append(nuevoObjeto)
        
        // Aumentar dificultad progresiva
        if score > 0 && score % 10 == 0 { // Cada 10 puntos sube velocidad
            velocidadBase += 0.2
        }
    }
    
    func actualizarJuego(altoPantalla: CGFloat) {
        // 1. Mover objetos hacia abajo
        for i in objetos.indices {
            objetos[i].y += velocidadBase
        }
        
        // 2. Detectar Colisiones
        // Altura del jugador aprox: altoPantalla - 150
        let playerY = altoPantalla - 150
        
        var indicesAEliminar: [Int] = []
        
        for i in objetos.indices {
            let obj = objetos[i]
            
            // Si el objeto está a la altura del jugador
            // Rango de colisión vertical (aprox 100px)
            if abs(obj.y - playerY) < 80 {
                // Y está en el MISMO CARRIL
                if obj.carril == carrilJugador {
                    if obj.esBueno {
                        score += 1
                    } else {
                        vidas -= 1
                        if vidas <= 0 { isGameOver = true }
                    }
                    indicesAEliminar.append(i) // Objeto consumido/chocado
                }
            }
            
            // Si sale de la pantalla
            if obj.y > altoPantalla + 100 {
                indicesAEliminar.append(i)
            }
        }
        
        // Limpiar
        for index in indicesAEliminar.reversed() {
            objetos.remove(at: index)
        }
    }
    
    func reiniciarJuego() {
        score = 0
        vidas = 3
        velocidadBase = 8.0
        carrilJugador = 1
        objetos.removeAll()
        isGameOver = false
    }
}

struct CarreraView_Previews: PreviewProvider {
    static var previews: some View {
        CarreraView()
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
