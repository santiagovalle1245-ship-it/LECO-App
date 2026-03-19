import SwiftUI

struct MinijuegosMenuView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    
                    // MARK: - Fondo y Decoraciones
                    // Establece un fondo vibrante y figuras semitransparentes
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.95, green: 0.6, blue: 0.1),
                            Color(red: 0.9, green: 0.3, blue: 0.1)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    
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
                    
                    // MARK: - Encabezado y Navegación
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
                            // ACCESIBILIDAD
                            .accessibilityLabel("Volver al menú principal")
                            .accessibilityHint("Toca dos veces para salir de los minijuegos")
                            .padding([.leading, .top], 30)
                            Spacer()
                        }
                        
                        Text("Minijuegos")
                            .font(.system(size: 70, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.4), radius: 6, y: 4)
                            .padding(.bottom, 10)
                        
                        // MARK: - Lista de Juegos
                        // Muestra todos los botones creados con la función reutilizable
                        ScrollView {
                            VStack(spacing: 30) {
                                NavigationLink(destination: PalabraPerdidaView()) { botonJuego(titulo: "🧠 Palabra Perdida", color: Color(red: 0.4, green: 0.3, blue: 0.7)) }
                                NavigationLink(destination: EncuentraPalabraView()) { botonJuego(titulo: "🖼️ Encuentra la Palabra", color: Color(red: 0.2, green: 0.6, blue: 0.4)) }
                                NavigationLink(destination: JuegoMemoriaView()) { botonJuego(titulo: "🃏 Juego de Memoria", color: Color(red: 0.2, green: 0.5, blue: 0.8)) }
                                NavigationLink(destination: TocaRapidoView()) { botonJuego(titulo: "⚡️ Toca Rápido", color: Color(red: 0.9, green: 0.3, blue: 0.5)) }
                                NavigationLink(destination: ClasificadorView()) { botonJuego(titulo: "🧺 El Clasificador", color: Color(red: 0.8, green: 0.4, blue: 0.9)) }
                                NavigationLink(destination: SimonDiceView()) { botonJuego(titulo: "🎹 Simón Dice", color: Color(red: 0.1, green: 0.8, blue: 0.5)) }
                                NavigationLink(destination: LluviaGlobosView()) { botonJuego(titulo: "🎈 Lluvia de Globos", color: Color(red: 0.2, green: 0.7, blue: 0.9)) }
                                NavigationLink(destination: AtrapaEstrellasView()) { botonJuego(titulo: "🌟 Atrapa Estrellas", color: Color(red: 0.1, green: 0.2, blue: 0.4)) }
                                NavigationLink(destination: CarreraView()) { botonJuego(titulo: "🏎️ Super Carrera", color: Color(red: 0.9, green: 0.2, blue: 0.2)) }
                                NavigationLink(destination: ViajeCiudadView()) { botonJuego(titulo: "🏙️ Aventura Urbana", color: Color(red: 0.3, green: 0.2, blue: 0.6)) }
                                
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
    
    // MARK: - Componentes UI (Reutilizables)
    // Función que genera el diseño de cada botón de minijuego
    func botonJuego(titulo: String, color: Color) -> some View {
        Text(titulo)
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .padding(25)
            .frame(maxWidth: .infinity)
            .background(color.opacity(0.9))
            .foregroundColor(.white)
            .cornerRadius(30)
            .shadow(color: .black.opacity(0.3), radius: 5, y: 5)
            // ACCESIBILIDAD APLICADA A TODOS LOS JUEGOS
            .accessibilityLabel("Juego: \(titulo)")
            .accessibilityHint("Toca dos veces para empezar este juego")
            .accessibilityAddTraits(.isButton)
    }
}

struct MinijuegosMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MinijuegosMenuView()
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
