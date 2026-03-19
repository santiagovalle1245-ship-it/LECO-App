import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    
                    // MARK: - Fondo y Degradados
                    // Configura el color de fondo de la pantalla principal
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.3, green: 0.1, blue: 0.6),
                            Color(red: 0.1, green: 0.5, blue: 0.9),
                            Color(red: 0.1, green: 0.8, blue: 0.9)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    // MARK: - Decoraciones Visuales
                    // Figuras geométricas y destellos para hacer la app más atractiva
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 900, height: 900)
                        .blur(radius: 80)
                        .position(x: 0, y: 0)
                    
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 800, height: 800)
                        .blur(radius: 80)
                        .position(x: geo.size.width, y: geo.size.height)
                    
                    Capsule()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 1000, height: 300)
                        .rotationEffect(.degrees(-45))
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    
                    Image(systemName: "sparkle")
                        .font(.system(size: 80))
                        .foregroundColor(.yellow.opacity(0.5))
                        .position(x: geo.size.width - 150, y: 200)
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white.opacity(0.3))
                        .position(x: 100, y: geo.size.height / 2 + 100)

                    // MARK: - Contenido Principal (Título y Logo)
                    VStack(spacing: 40) {
                        
                        Text(" LECO (:)-/-[ ")
                            .font(.system(size: 90, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                            .padding(.top, 60)
                        
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 350)
                            .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
                        
                        Spacer()
                        
                        // MARK: - Botones de Navegación
                        // Botones interactivos con soporte de accesibilidad (VoiceOver)
                        VStack(spacing: 40) {
                            
                            // Botón de Cuentos
                            NavigationLink(destination: CatalogoView()) {
                                HStack(spacing: 20) {
                                    Image(systemName: "book.fill")
                                    Text("Leer Cuentos")
                                }
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .padding(35)
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(colors: [Color.purple, Color.blue], startPoint: .leading, endPoint: .trailing)
                                )
                                .foregroundColor(.white)
                                .cornerRadius(40)
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.white.opacity(0.4), lineWidth: 3)
                                )
                            }
                            // ACCESIBILIDAD
                            .accessibilityLabel("Leer Cuentos")
                            .accessibilityHint("Toca dos veces para abrir la biblioteca de cuentos")
                            
                            // Botón de Minijuegos
                            NavigationLink(destination: MinijuegosMenuView()) {
                                HStack(spacing: 20) {
                                    Image(systemName: "wand.and.stars")
                                    Text("Jugar Minijuegos")
                                }
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .padding(35)
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(colors: [Color.orange, Color.red], startPoint: .leading, endPoint: .trailing)
                                )
                                .foregroundColor(.white)
                                .cornerRadius(40)
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.white.opacity(0.4), lineWidth: 3)
                                )
                            }
                            // ACCESIBILIDAD
                            .accessibilityLabel("Jugar Minijuegos")
                            .accessibilityHint("Toca dos veces para ver la lista de juegos divertidos")
                        }
                        .padding(.bottom, 80)
                    }
                    .padding(.horizontal, 100)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
