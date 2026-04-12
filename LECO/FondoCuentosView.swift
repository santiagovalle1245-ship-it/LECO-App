import SwiftUI

struct FondoCuentosView: View {
    // Usamos un solo interruptor para controlar todo el flujo de colores
    @State private var animarFondo = false
    
    var body: some View {
        ZStack {
            // Capa 1: Fondo oscuro base para que los colores resalten
            Color(red: 0.05, green: 0.05, blue: 0.15)
                .ignoresSafeArea()
            
            // Capa 2: LAS AURORAS GIGANTES
            
            // 1. Mancha Superior Izquierda (Rosa)
            Circle()
                .fill(Color.pink.opacity(0.7))
                .frame(width: 600)
                .blur(radius: 150)
                .offset(x: animarFondo ? 200 : -200, y: animarFondo ? -100 : -300)
            
            // 2. Mancha Superior Derecha (Cian)
            Circle()
                .fill(Color.cyan.opacity(0.6))
                .frame(width: 700)
                .blur(radius: 150)
                .offset(x: animarFondo ? -200 : 300, y: animarFondo ? 200 : -200)
            
            // 3. Mancha Inferior Izquierda (Morado Profundo)
            Circle()
                .fill(Color.purple.opacity(0.7))
                .frame(width: 800)
                .blur(radius: 200)
                .offset(x: animarFondo ? 300 : -300, y: animarFondo ? 300 : 100)
            
            // 4. Mancha Inferior Derecha (Azul Brillante)
            Circle()
                .fill(Color.blue.opacity(0.6))
                .frame(width: 600)
                .blur(radius: 150)
                .offset(x: animarFondo ? -300 : 200, y: animarFondo ? -200 : 400)
        }
        .onAppear {
            // Animación súper fluida que dura 10 segundos en ir y 10 en regresar
            withAnimation(.easeInOut(duration: 12).repeatForever(autoreverses: true)) {
                animarFondo = true
            }
        }
    }
}

struct FondoCuentosView_Previews: PreviewProvider {
    static var previews: some View {
        FondoCuentosView()
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
