import SwiftUI

struct FondoJuegosView: View {
    // 1. Agregamos dos interruptores más para los nuevos píxeles
    @State private var moverPixel1 = false
    @State private var moverPixel2 = false
    @State private var moverPixel3 = false
    @State private var moverPixel4 = false
    @State private var moverPixel5 = false // ¡NUEVO!
    @State private var moverPixel6 = false // ¡NUEVO!
    
    var body: some View {
        ZStack {
            // Fondo base oscuro
            Color(red: 0.1, green: 0.1, blue: 0.15)
                .ignoresSafeArea()
            
            // Cuadrícula retro (GameBoy style)
            VStack(spacing: 40) {
                ForEach(0..<20) { _ in Divider().background(Color.white.opacity(0.05)) }
            }
            HStack(spacing: 40) {
                ForEach(0..<15) { _ in Divider().background(Color.white.opacity(0.05)).frame(width: 1) }
            }
            
            // LOS PÍXELES ORIGINALES
 
            // Píxel Verde
            Rectangle()
                .fill(Color.green)
                .frame(width: 80, height: 40)
                .shadow(color: .green, radius: 10)
                .offset(x: moverPixel1 ? 500 : -500, y: -200)
            
            // Píxel Cyan
            Rectangle()
                .fill(Color.cyan)
                .frame(width: 40, height: 120)
                .shadow(color: .cyan, radius: 10)
                .offset(x: -150, y: moverPixel2 ? 600 : -600)
            
            // Píxel Amarillo
            Rectangle()
                .fill(Color.yellow)
                .frame(width: 120, height: 40)
                .shadow(color: .yellow, radius: 10)
                .offset(x: moverPixel3 ? -500 : 500, y: 100)
            
            // Píxel Magenta
            Rectangle()
                .fill(Color.pink)
                .frame(width: 40, height: 80)
                .shadow(color: .pink, radius: 10)
                .offset(x: 200, y: moverPixel4 ? -600 : 600)

            // Píxel Naranja (Cruza rápido por abajo)
            Rectangle()
                .fill(Color.orange)
                .frame(width: 60, height: 40)
                .shadow(color: .orange, radius: 10)
                .offset(x: moverPixel5 ? 500 : -500, y: 350)
            
            // Píxel Morado (Cae lentamente por la derecha)
            Rectangle()
                .fill(Color.purple)
                .frame(width: 40, height: 160) // Es más largo
                .shadow(color: .purple, radius: 10)
                .offset(x: 300, y: moverPixel6 ? 600 : -600)
        }
        .onAppear {
            // Animaciones originales
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) { moverPixel1 = true }
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) { moverPixel2 = true }
            withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) { moverPixel3 = true }
            withAnimation(.linear(duration: 7).repeatForever(autoreverses: false)) { moverPixel4 = true }
            
            // Animaciones nuevas (Duraciones diferentes para que no se muevan al mismo tiempo)
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) { moverPixel5 = true } // Va muy rápido (3 seg)
            withAnimation(.linear(duration: 9).repeatForever(autoreverses: false)) { moverPixel6 = true } // Va muy lento (9 seg)
        }
    }
}

struct FondoJuegosView_Previews: PreviewProvider {
    static var previews: some View {
        FondoJuegosView()
    }
}
