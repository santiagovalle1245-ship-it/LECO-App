import SwiftUI

struct EncuentraPalabraView: View {
    @Environment(\.dismiss) var dismiss
    
    struct Item {
        let imagen: String
        let opciones: [String]
        let respuestaCorrecta: String
    }
    
    // Base de datos de imágenes y palabras
    let items: [Item] = [
        Item(imagen: "gato", opciones: ["Gato", "Perro", "Silla"], respuestaCorrecta: "Gato"),
        Item(imagen: "sol", opciones: ["Sol", "Luna", "Agua"], respuestaCorrecta: "Sol"),
        Item(imagen: "pelota", opciones: ["Pelota", "Libro", "Manzana"], respuestaCorrecta: "Pelota"),
        Item(imagen: "arbol", opciones: ["Arbol", "Pajaro", "Mesa"], respuestaCorrecta: "Arbol"),
        Item(imagen: "pez", opciones: ["Pez", "Perro", "Coche"], respuestaCorrecta: "Pez"),
        Item(imagen: "casa", opciones: ["Casa", "Montana", "Silla"], respuestaCorrecta: "Casa"),
        Item(imagen: "zapato", opciones: ["Zapato", "Sombrero", "Libro"], respuestaCorrecta: "Zapato"),
        Item(imagen: "manzana", opciones: ["Manzana", "Pera", "Plato"], respuestaCorrecta: "Manzana"),
        Item(imagen: "pajaro", opciones: ["Pajaro", "Gato", "Reloj"], respuestaCorrecta: "Pajaro"),
        Item(imagen: "coche", opciones: ["Coche", "Bicicleta", "Mesa"], respuestaCorrecta: "Coche")
    ]
    
    @State private var indexActual = 0
    @State private var score = 0
    @State private var showFeedback = false
    @State private var feedbackText = ""
    @State private var feedbackColor = Color.clear
    @State private var juegoTerminado = false
    @State private var opcionesMezcladas: [String] = []
    @State private var animacionImagen = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // --- FONDO INTENSO (Rosa/Morado) ---
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.9, green: 0.3, blue: 0.5), // Rosa
                        Color(red: 0.6, green: 0.2, blue: 0.6)   // Morado
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // --- DECORACIONES ---
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 200))
                    .foregroundColor(.white.opacity(0.15))
                    .rotationEffect(.degrees(-15))
                    .position(x: 120, y: 150)
                
                Image(systemName: "hand.tap.fill")
                    .font(.system(size: 150))
                    .foregroundColor(.white.opacity(0.10))
                    .position(x: geo.size.width - 100, y: geo.size.height / 2 + 100)
                
                Circle()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 400, height: 400)
                    .position(x: geo.size.width - 50, y: 80)
                
                Capsule()
                    .fill(Color.white.opacity(0.10))
                    .frame(width: 500, height: 150)
                    .rotationEffect(.degrees(30))
                    .position(x: 100, y: geo.size.height - 100)

                VStack(spacing: 20) {
                    
                    // Botón de Volver
                    HStack {
                        Button(action: { dismiss() }) {
                            Label("Volver", systemImage: "arrowshape.turn.up.left.fill")
                                .font(.title3)
                                .padding(12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(15)
                                .shadow(radius: 3)
                        }
                        .padding([.leading, .top], 30)
                        Spacer()
                    }
                    
                    Text("Encuentra la Palabra")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5)
                    
                    if !juegoTerminado {
                        
                        // --- ¡LA LÍNEA QUE FALTABA! ---
                        let itemActual = items[indexActual]
                        // --- FIN DE LA CORRECCIÓN ---
                        
                        // Imagen con animación
                        Image(itemActual.imagen)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .padding()
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(30)
                            .shadow(radius: 8, y: 5)
                            .scaleEffect(animacionImagen ? 1.15 : 1.0)
                            .rotationEffect(.degrees(animacionImagen ? 5 : 0))
                            .animation(.spring(response: 0.4, dampingFraction: 0.5), value: animacionImagen)
                        
                        // Opciones
                        VStack(spacing: 20) {
                            ForEach(opcionesMezcladas, id: \.self) { opcion in
                                Button(action: {
                                    checkAnswer(opcion)
                                }) {
                                    Text(opcion)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(red: 0.6, green: 0.2, blue: 0.6))
                                        .padding(25)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .cornerRadius(25)
                                        .shadow(radius: 4, y: 4)
                                }
                            }
                        }
                        .padding(.horizontal, 120)
                        
                        // Feedback
                        if showFeedback {
                            Text(feedbackText)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(feedbackColor == .red ? .white : .green)
                                .padding(15)
                                .background(feedbackColor == .red ? Color.red.opacity(0.8) : Color.white.opacity(0.8))
                                .cornerRadius(20)
                                .transition(.scale)
                                .animation(.easeInOut, value: showFeedback)
                        }
                        
                        Spacer()
                        
                        Text("Progreso: \(indexActual + 1) / \(items.count)  |  Puntos: \(score)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Spacer()
                        
                    } else {
                        // --- Pantalla de Fin de Juego ---
                        Spacer()
                        VStack(spacing: 30) {
                            Text("¡Juego Terminado! 🎉")
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Puntos totales: \(score) de \(items.count)")
                                .font(.largeTitle)
                                .foregroundColor(.white.opacity(0.9))
                            
                            Button("Jugar de Nuevo") {
                                reiniciarJuego()
                            }
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(25)
                            .background(Color.white)
                            .foregroundColor(Color(red: 0.9, green: 0.3, blue: 0.5))
                            .cornerRadius(30)
                            .shadow(radius: 5)
                        }
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            // Mezclamos las opciones solo la primera vez que aparece
            opcionesMezcladas = items[indexActual].opciones.shuffled()
        }
        .navigationBarHidden(true)
    }
    
    func checkAnswer(_ opcion: String) {
        let itemActual = items[indexActual]
        
        if opcion == itemActual.respuestaCorrecta {
            score += 1
            feedbackText = "¡Correcto!"
            feedbackColor = .green
            animacionImagen = true
        } else {
            feedbackText = "Oops, era \(itemActual.respuestaCorrecta)"
            feedbackColor = .red
            animacionImagen = false
        }
        
        withAnimation { showFeedback = true }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            showFeedback = false
            animacionImagen = false
            if indexActual < items.count - 1 {
                indexActual += 1
                // Mezclamos las opciones para el siguiente ítem
                opcionesMezcladas = items[indexActual].opciones.shuffled()
            } else {
                juegoTerminado = true
            }
        }
    }
    
    func reiniciarJuego() {
        indexActual = 0
        score = 0
        opcionesMezcladas = items[indexActual].opciones.shuffled()
        juegoTerminado = false
    }
}

struct EncuentraPalabraView_Previews: PreviewProvider {
    static var previews: some View {
        EncuentraPalabraView()
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
