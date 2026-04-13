import SwiftUI

struct FondoLecturaView: View {
    // Interruptores para las olas
    @State private var moverOla1 = false
    @State private var moverOla2 = false
    @State private var moverOla3 = false
    
    // --- NUEVO: Interruptor para el brillo de las estrellas ---
    // Esto hará que las estrellas "pulsen" suavemente
    @State private var titilarEstrellas = false
    
    var body: some View {
        ZStack {
            // 1. EL FONDO DE NOCHE
            LinearGradient(colors: [Color(red: 0.02, green: 0.05, blue: 0.12), Color(red: 0.1, green: 0.1, blue: 0.2)],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()
            
            // --- NUEVO: 3. LAS ESTRELLAS MÁGICAS (Detrás de las olas) ---
            // Usamos GeometryReader para ubicarlas por coordenadas exactas
            GeometryReader { geo in
                ZStack {
                    // ESTRELLA 1 (Arriba a la izquierda)
                    crearEstrella(size: 6, color: .yellow)
                        .position(x: geo.size.width * 0.15, y: geo.size.height * 0.10)
                        // Animación de parpadeo suave
                        .opacity(titilarEstrellas ? 0.3 : 1.0)
                    
                    // ESTRELLA 2 (Un poco más abajo y al centro)
                    crearEstrella(size: 8, color: Color(red: 1.0, green: 0.9, blue: 0.5))
                        .position(x: geo.size.width * 0.45, y: geo.size.height * 0.18)
                        .opacity(titilarEstrellas ? 1.0 : 0.4) // Parpadea al revés que la 1
                    
                    // ESTRELLA 3 (Arriba a la derecha)
                    crearEstrella(size: 5, color: .white)
                        .position(x: geo.size.width * 0.85, y: geo.size.height * 0.08)
                        .opacity(titilarEstrellas ? 0.5 : 1.0)
                }
            }
            .ignoresSafeArea()
            
            // 2. LAS OLAS "BIOLUMINISCENTES"
            VStack {
                Spacer()
                
                ZStack {
                    // OLA 1 (Atrás) - Azul Eléctrico
                    Ellipse()
                        .fill(
                            LinearGradient(colors: [.blue.opacity(0.4), .clear], startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: 900, height: 350)
                        .offset(x: moverOla1 ? -60 : 60, y: 40)
                        .shadow(color: Color.blue.opacity(0.3), radius: 20, x: 0, y: -5)
                    
                    // OLA 2 (Medio) - Turquesa/Cian
                    Ellipse()
                        .fill(
                            LinearGradient(colors: [Color.cyan.opacity(0.5), .clear], startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: 1000, height: 280)
                        .offset(x: moverOla2 ? 70 : -70, y: 80)
                        .shadow(color: Color.cyan.opacity(0.4), radius: 25, x: 0, y: -8)
                    
                    // OLA 3 (Frente) - Violeta Neón
                    Ellipse()
                        .fill(
                            LinearGradient(colors: [Color.purple.opacity(0.5), .clear], startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: 950, height: 220)
                        .offset(x: moverOla3 ? -50 : 50, y: 120)
                        .shadow(color: Color.purple.opacity(0.4), radius: 30, x: 0, y: -10)
                }
                .padding(.bottom, -80)
            }
            .ignoresSafeArea()
        }
        .onAppear {
            // Animaciones de las olas
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                moverOla1.toggle()
            }
            withAnimation(.easeInOut(duration: 7).repeatForever(autoreverses: true)) {
                moverOla2.toggle()
            }
            withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                moverOla3.toggle()
            }
            
            // --- NUEVO: Animación de parpadeo de estrellas ---
            // Es muy lenta y suave para no distraer al leer
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                titilarEstrellas.toggle()
            }
        }
    }
    
    // --- NUEVO: FUNCIÓN AUXILIAR PARA CREAR UNA ESTRELLA ---
    // Esta función nos ayuda a no repetir código y a darle el efecto de resplandor
    func crearEstrella(size: CGFloat, color: Color) -> some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            // EL SECRETO DEL BRILLO: Un resplandor borroso alrededor
            .shadow(color: color.opacity(0.8), radius: 6, x: 0, y: 0)
    }
}
#Preview {
    FondoLecturaView()
}
