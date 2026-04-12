import SwiftUI

struct FondoAnimadoView: View {
    @State private var animarFondo = false
    
    var body: some View {
        ZStack {

            // CAPA 1: FONDO DEGRADADO ANIMADO
            // Mezcla los colores y cambia la dirección suavemente
            LinearGradient(
                colors: [.cyan.opacity(0.5), .purple.opacity(0.4), .blue.opacity(0.5)],
                startPoint: animarFondo ? .topLeading : .bottomTrailing,
                endPoint: animarFondo ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            // CAPA 2: SLIMES DE PROFUNDIDAD (En las orillas)
            Circle()
                .fill(Color.orange.opacity(0.4))
                .frame(width: 300)
                .blur(radius: 40)
                .offset(x: animarFondo ? 150 : -50, y: animarFondo ? -300 : -200)
            
            Circle()
                .fill(Color.pink.opacity(0.4))
                .frame(width: 250)
                .blur(radius: 40)
                .offset(x: animarFondo ? -150 : 100, y: animarFondo ? 300 : 200)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                animarFondo = true
            }
        }
    }
}

// Vista previa para Xcode
struct FondoAnimadoView_Previews: PreviewProvider {
    static var previews: some View {
        FondoAnimadoView()
    }
}
