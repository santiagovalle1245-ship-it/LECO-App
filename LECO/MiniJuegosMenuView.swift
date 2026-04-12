import SwiftUI

struct MinijuegosMenuView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    
                    // CAMBIO: Nuestro nuevo fondo retro animado
                    FondoJuegosView()
                    
                    // Encabezado y Navegación
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
                        
                        // Lista de Juegos
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
