import SwiftUI

// - 1. El Molde para cada Carta -
struct CartaMemoria: Identifiable, Equatable {
    let id = UUID()
    let imagenNombre: String
    var estaVolteada = false
    var estaEmparejada = false
}

struct JuegoMemoriaView: View {
    @Environment(\.dismiss) var dismiss
    
    // Nombres de las 6 imágenes
    let nombresImagenes = ["memoria_coche", "memoria_estrella", "memoria_luna", "memoria_manzana", "memoria_pelota", "memoria_sol"]
    
    // Variables del Juego
    @State private var cartas: [CartaMemoria] = []
    @State private var cartasVolteadas: [CartaMemoria] = []
    @State private var movimientos = 0
    @State private var juegoTerminado = false
    
    // Cuadrícula de 3 columnas (se ve bien en iPad con cartas grandes)
    let columnas: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
               //Fondo
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.1, green: 0.2, blue: 0.5), // Azul oscuro
                        Color(red: 0.3, green: 0.1, blue: 0.4)   // Púrpura oscuro
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Decoraciones
                
                Image(systemName: "sparkles")
                    .font(.system(size: 200))
                    .foregroundColor(.white.opacity(0.15))
                    .position(x: 150, y: 180)
                
                Image(systemName: "star.fill")
                    .font(.system(size: 150))
                    .foregroundColor(.white.opacity(0.12))
                    .rotationEffect(.degrees(-15))
                    .position(x: geo.size.width - 100, y: geo.size.height / 2)
                
                Circle()
                    .fill(Color.white.opacity(0.10))
                    .frame(width: 400, height: 400)
                    .position(x: 80, y: geo.size.height - 100)
                
                Image(systemName: "star.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white.opacity(0.15))
                    .position(x: geo.size.width - 150, y: geo.size.height - 150)
                
                // Contenido:
                
                VStack(spacing: 30) {
                    
                    // Encabezado
                    HStack {
                        Button(action: { dismiss() }) {
                            Label("Volver", systemImage: "arrowshape.turn.up.left.fill")
                                .font(.title3) // Fuente más grande
                                .padding(12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(15)
                                .shadow(radius: 3)
                        }
                        .padding([.leading, .top], 30)
                        
                        Spacer()
                        
                        Text("Movimientos: \(movimientos)")
                            .font(.title) // Fuente grande
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(15)
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(20)
                            .padding([.trailing, .top], 30)
                    }
                    
                    Text("Juego de Memoria")
                        .font(.system(size: 60, weight: .bold)) // Título grande
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5)
                    
                    // Cuadrícula de Cartas
                    LazyVGrid(columns: columnas, spacing: 30) { // Más espaciado
                        ForEach(cartas) { carta in
                            VistaCarta(carta: carta)
                                .onTapGesture {
                                    voltearCarta(carta)
                                }
                        }
                    }
                    .padding(.horizontal, 80) // Márgenes grandes
                    
                    Spacer()
                }
                
                // Pantalla de Fin de Juego
                if juegoTerminado {
                    VStack(spacing: 30) {
                        Text("¡Ganaste! 🎉")
                            .font(.system(size: 70, weight: .bold))
                        Text("Movimientos Totales: \(movimientos)")
                            .font(.largeTitle)
                        
                        Button("Jugar de Nuevo") {
                            reiniciarJuego()
                        }
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(25)
                        .background(Color.white)
                        .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.5)) // Azul
                        .cornerRadius(30)
                        .shadow(radius: 5)
                    }
                    .padding(60) // Padding grande
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(30)
                    .foregroundColor(.white)
                    .transition(.scale) // Animación
                }
            }
        }
        .onAppear {
            reiniciarJuego()
        }
        .navigationBarHidden(true)
    }
    
    // --- Vista Interna: El Diseño de una Carta (MÁS GRANDE) ---
    struct VistaCarta: View {
        let carta: CartaMemoria
        
        var body: some View {
            ZStack {
                if carta.estaVolteada || carta.estaEmparejada {
                    // Cara de la Carta (Imagen)
                    RoundedRectangle(cornerRadius: 20) // Más redondeado
                        .fill(Color.white)
                    Image(carta.imagenNombre)
                        .resizable()
                        .scaledToFit()
                        .padding(20) // Más padding interno
                } else {
                    // Dorso de la Carta (Color)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.7, green: 0.6, blue: 0.9)) // Color lavanda
                    Image(systemName: "questionmark")
                        .font(.system(size: 50, weight: .bold)) // Ícono grande
                        .foregroundColor(.white)
                }
            }
            .frame(minHeight: 180, maxHeight: 200) // Mucho más altas
            .shadow(radius: 5, y: 5)
        }
    }
    
    // --- Lógica del Juego (sin cambios) ---
    
    func reiniciarJuego() {
        let paresDeCartas = nombresImagenes.map { nombreImagen in
            [CartaMemoria(imagenNombre: nombreImagen), CartaMemoria(imagenNombre: nombreImagen)]
        }.flatMap { $0 }
        
        cartas = paresDeCartas.shuffled()
        
        movimientos = 0
        juegoTerminado = false
        cartasVolteadas = []
    }
    
    func voltearCarta(_ carta: CartaMemoria) {
        // No hacer nada si ya está emparejada o si ya hay 2 volteadas o si es la misma carta
        if carta.estaEmparejada || cartasVolteadas.count == 2 || cartasVolteadas.contains(where: { $0.id == carta.id }) {
            return
        }
        
        if let index = cartas.firstIndex(where: { $0.id == carta.id }) {
            cartas[index].estaVolteada = true
            cartasVolteadas.append(cartas[index])
            
            if cartasVolteadas.count == 2 {
                movimientos += 1
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    compararCartas()
                }
            }
        }
    }
    
    func compararCartas() {
        guard cartasVolteadas.count == 2 else { return }
        
        let carta1 = cartasVolteadas[0]
        let carta2 = cartasVolteadas[1]
        
        let index1 = cartas.firstIndex(where: { $0.id == carta1.id })!
        let index2 = cartas.firstIndex(where: { $0.id == carta2.id })!
        
        if carta1.imagenNombre == carta2.imagenNombre {
            cartas[index1].estaEmparejada = true
            cartas[index2].estaEmparejada = true
            
            if cartas.allSatisfy({ $0.estaEmparejada }) {
                withAnimation {
                    juegoTerminado = true
                }
            }
        } else {
            cartas[index1].estaVolteada = false
            cartas[index2].estaVolteada = false
        }
        
        cartasVolteadas = []
    }
}


struct JuegoMemoriaView_Previews: PreviewProvider {
    static var previews: some View {
        JuegoMemoriaView()
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
