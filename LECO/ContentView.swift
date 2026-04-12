import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    
                    // 1. Capa base: Nuestro fondo animado mágico
                    FondoAnimadoView()
                    
                    // 2. Contenido Principal (Título y Botones centrados)
                    VStack(spacing: 60) {
                        
                        // Empuja el contenido hacia abajo
                        Spacer()
                        
                        // Título de la app
                        Text(" LECO (:)-/-[ ")
                            .font(.system(size: 90, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                        
                        // Botones de Navegación
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
                            .accessibilityLabel("Jugar Minijuegos")
                            .accessibilityHint("Toca dos veces para ver la lista de juegos divertidos")
                        }
                        
                        // Empuja el contenido hacia arriba
                        Spacer()
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
