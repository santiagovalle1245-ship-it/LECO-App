import SwiftUI

struct ClasificadorView: View {
    @Environment(\.dismiss) var dismiss
    
    // --- 1. Estructura de Datos ---
    struct ItemClasificador {
        let id = UUID()
        let imagen: String
        let esComida: Bool // True = Comida, False = Juguete
    }
    
    // --- 2. Base de Datos de Items ---
    @State private var items: [ItemClasificador] = [
        ItemClasificador(imagen: "clas_manzana", esComida: true),
        ItemClasificador(imagen: "clas_balon", esComida: false),
        ItemClasificador(imagen: "clas_pizza", esComida: true),
        ItemClasificador(imagen: "clas_oso", esComida: false),
        ItemClasificador(imagen: "clas_helado", esComida: true),
        ItemClasificador(imagen: "clas_robot", esComida: false),
        ItemClasificador(imagen: "clas_platano", esComida: true),
        ItemClasificador(imagen: "clas_coche", esComida: false)
    ].shuffled() // Mezclamos al inicio
    
    // --- 3. Variables de Estado ---
    @State private var indexActual = 0
    @State private var score = 0
    @State private var offset = CGSize.zero // Posición del objeto mientras se arrastra
    @State private var isDragging = false
    @State private var feedbackMessage = ""
    @State private var showFeedback = false
    @State private var gameEnded = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // --- FONDO INTENSO (Morado/Rosa) ---
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.6, green: 0.2, blue: 0.8), // Morado
                        Color(red: 0.9, green: 0.4, blue: 0.6)   // Rosa fuerte
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // --- DECORACIONES ---
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 500, height: 500)
                    .position(x: 100, y: 100)
                
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 600, height: 200)
                    .rotationEffect(.degrees(45))
                    .position(x: geo.size.width - 50, y: geo.size.height / 2)
                
                VStack {
                    // Encabezado
                    HStack {
                        Button(action: { dismiss() }) {
                            Label("Volver", systemImage: "arrowshape.turn.up.left.fill")
                                .font(.title3)
                                .padding(12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(15)
                        }
                        Spacer()
                        Text("Puntos: \(score)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding([.horizontal, .top], 40)
                    
                    Text("¡Arrastra a la canasta correcta!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    // --- ÁREA DE JUEGO ---
                    if !gameEnded {
                        ZStack {
                            // El Objeto para Arrastrar
                            if indexActual < items.count {
                                Image(items[indexActual].imagen)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 220, height: 220) // Tamaño grande para iPad
                                    .shadow(radius: 10)
                                    .scaleEffect(isDragging ? 1.2 : 1.0) // Se hace grande al agarrarlo
                                    .offset(offset) // Aquí se aplica el movimiento del dedo
                                    .gesture(
                                        DragGesture()
                                            .onChanged { gesture in
                                                offset = gesture.translation
                                                isDragging = true
                                            }
                                            .onEnded { gesture in
                                                isDragging = false
                                                checkDrop(width: geo.size.width)
                                            }
                                    )
                                    .animation(.spring(), value: offset)
                            }
                        }
                        .zIndex(1) // Asegura que el objeto pase por encima de todo
                    } else {
                        // Pantalla Final
                        VStack(spacing: 20) {
                            Text("¡Bien hecho! 🎉")
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(.white)
                            Button("Jugar de Nuevo") {
                                reiniciarJuego()
                            }
                            .font(.title)
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                    }
                    
                    Spacer()
                    
                    // --- LAS CANASTAS (Zonas de Caída) ---
                    HStack(spacing: 50) {
                        // Canasta Izquierda: COMIDA
                        VStack {
                            Image(systemName: "carrot.fill") // Icono de comida
                                .font(.system(size: 60))
                                .foregroundColor(.orange)
                            Text("Comida")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.orange, lineWidth: 5)
                        )
                        
                        // Canasta Derecha: JUGUETES
                        VStack {
                            Image(systemName: "teddybear.fill") // Icono de juguete
                                .font(.system(size: 60))
                                .foregroundColor(.blue)
                            Text("Juguetes")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.blue, lineWidth: 5)
                        )
                    }
                    .padding(.horizontal, 50)
                    .padding(.bottom, 30)
                }
                
                // Feedback visual flotante
                if showFeedback {
                    Text(feedbackMessage)
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(20)
                        .transition(.scale)
                        .zIndex(2)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // --- LÓGICA DEL ARRASTRE ---
    func checkDrop(width: CGFloat) {
        let item = items[indexActual]
        let zonaIzquierda = -width / 4 // Umbral para soltar a la izquierda
        let zonaDerecha = width / 4    // Umbral para soltar a la derecha
        
        // Caso 1: Soltó a la IZQUIERDA (Comida)
        if offset.width < zonaIzquierda {
            if item.esComida {
                acierto()
            } else {
                error()
            }
        }
        // Caso 2: Soltó a la DERECHA (Juguetes)
        else if offset.width > zonaDerecha {
            if !item.esComida {
                acierto()
            } else {
                error()
            }
        }
        // Caso 3: Soltó en el medio (No decidió)
        else {
            offset = .zero // Regresa al centro
        }
    }
    
    func acierto() {
        score += 1
        feedbackMessage = "¡Correcto! ✅"
        
        withAnimation {
            showFeedback = true
            // Mueve el objeto fuera de la pantalla para simular que entró
            offset = CGSize(width: offset.width * 2, height: 500)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showFeedback = false
            offset = .zero // Resetea posición para el siguiente
            if indexActual < items.count - 1 {
                indexActual += 1
            } else {
                gameEnded = true
            }
        }
    }
    
    func error() {
        feedbackMessage = "¡Intenta de nuevo! ❌"
        withAnimation(.default) { // Animación rápida
            showFeedback = true
            offset = .zero // Regresa al centro inmediatamente (rebote)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showFeedback = false
        }
    }
    
    func reiniciarJuego() {
        items.shuffle()
        indexActual = 0
        score = 0
        gameEnded = false
        offset = .zero
    }
}

struct ClasificadorView_Previews: PreviewProvider {
    static var previews: some View {
        ClasificadorView()
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
