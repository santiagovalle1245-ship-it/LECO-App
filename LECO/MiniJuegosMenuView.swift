import SwiftUI

struct MinijuegosMenuView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    // --- FONDO INTENSO (Naranja/Rojo) ---
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.95, green: 0.6, blue: 0.1), // Naranja vibrante
                            Color(red: 0.9, green: 0.3, blue: 0.1)   // Rojo-Naranja oscuro
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    
                    // --- DECORACIONES ---
                    Capsule()
                        .fill(Color.white.opacity(0.30))
                        .frame(width: 600, height: 200)
                        .rotationEffect(.degrees(-35))
                        .position(x: 100, y: geo.size.height / 2 - 100)
                    
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 500, height: 500)
                        .position(x: geo.size.width - 100, y: 150)
                    
                    Image(systemName: "gamecontroller.fill")
                        .font(.system(size: 150))
                        .foregroundColor(.white.opacity(0.20))
                        .rotationEffect(.degrees(15))
                        .position(x: geo.size.width - 150, y: geo.size.height - 150)
                    
                    Image(systemName: "puzzlepiece.extension.fill")
                        .font(.system(size: 120))
                        .foregroundColor(.white.opacity(0.18))
                        .position(x: 100, y: geo.size.height - 200)
                    
                    
                    // --- CONTENIDO ---
                    VStack(spacing: 20) {
                        // Encabezado
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
                        
                        // --- TÍTULO CON NUEVA TIPOGRAFÍA ---
                        Text("Minijuegos")
                            .font(.system(size: 70, weight: .heavy, design: .rounded)) // Tipografía redondeada
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.4), radius: 6, y: 4)
                            .padding(.bottom, 10)
                        
                        // Lista de Juegos Desplazable
                        ScrollView {
                            VStack(spacing: 30) {
                                
                                // 1. Palabra Perdida
                                NavigationLink(destination: PalabraPerdidaView()) {
                                    botonJuego(titulo: "🧠 Palabra Perdida", color: Color(red: 0.4, green: 0.3, blue: 0.7))
                                }
                                
                                // 2. Encuentra la Palabra
                                NavigationLink(destination: EncuentraPalabraView()) {
                                    botonJuego(titulo: "🖼️ Encuentra la Palabra", color: Color(red: 0.2, green: 0.6, blue: 0.4))
                                }
                                
                                // 3. Juego de Memoria
                                NavigationLink(destination: JuegoMemoriaView()) {
                                    botonJuego(titulo: "🃏 Juego de Memoria", color: Color(red: 0.2, green: 0.5, blue: 0.8))
                                }
                                
                                // 4. Toca Rápido
                                NavigationLink(destination: TocaRapidoView()) {
                                    botonJuego(titulo: "⚡️ Toca Rápido", color: Color(red: 0.9, green: 0.3, blue: 0.5))
                                }
                                
                                // 5. El Clasificador
                                NavigationLink(destination: ClasificadorView()) {
                                    botonJuego(titulo: "🧺 El Clasificador", color: Color(red: 0.8, green: 0.4, blue: 0.9))
                                }
                                
                                // 6. Simón Dice
                                NavigationLink(destination: SimonDiceView()) {
                                    botonJuego(titulo: "🎹 Simón Dice", color: Color(red: 0.1, green: 0.8, blue: 0.5))
                                }
                                
                                // 7. Lluvia de Globos
                                NavigationLink(destination: LluviaGlobosView()) {
                                    botonJuego(titulo: "🎈 Lluvia de Globos", color: Color(red: 0.2, green: 0.7, blue: 0.9))
                                }
                                
                                // 8. Atrapa Estrellas
                                NavigationLink(destination: AtrapaEstrellasView()) {
                                    botonJuego(titulo: "🌟 Atrapa Estrellas", color: Color(red: 0.1, green: 0.2, blue: 0.4))
                                }
                                
                                // 9. Super Carrera
                                NavigationLink(destination: CarreraView()) {
                                    botonJuego(titulo: "🏎️ Super Carrera", color: Color(red: 0.9, green: 0.2, blue: 0.2))
                                }
                                
                                // 10. Aventura Urbana
                                NavigationLink(destination: ViajeCiudadView()) {
                                    botonJuego(titulo: "🏙️ Aventura Urbana", color: Color(red: 0.3, green: 0.2, blue: 0.6))
                                }
                                
                                // Espacio extra al final
                                Spacer().frame(height: 50)
                            }
                            .padding(.horizontal, 120)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
    
    func botonJuego(titulo: String, color: Color) -> some View {
        Text(titulo)
            .font(.system(size: 28, weight: .bold, design: .rounded)) // También actualicé la fuente de los botones
            .padding(25)
            .frame(maxWidth: .infinity)
            .background(color.opacity(0.9))
            .foregroundColor(.white)
            .cornerRadius(30)
            .shadow(color: .black.opacity(0.3), radius: 5, y: 5)
    }
}

struct MinijuegosMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MinijuegosMenuView()
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
