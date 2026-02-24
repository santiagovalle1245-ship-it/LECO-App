import SwiftUI
import Combine

struct TocaRapidoView: View {
    @Environment(\.dismiss) var dismiss
    
    // 1. Variables del Juego
    @State private var score = 0
    @State private var targetPosition: CGPoint = .zero
    @State private var isTargetVisible = false
    @State private var gameTimeRemaining = 30
    @State private var isGameOver = false
    
    // 2. Los Temporizadores (Con la corrección de @State)
    @State private var gameClockTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var targetTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Fondo
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.2, green: 0.8, blue: 0.9), // Cian eléctrico
                        Color(red: 0.5, green: 0.4, blue: 0.9)   // Violeta
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Decoraciones
                Image(systemName: "bolt.fill")
                    .font(.system(size: 200))
                    .foregroundColor(.white.opacity(0.15))
                    .rotationEffect(.degrees(25))
                    .position(x: 150, y: 180)
                
                Image(systemName: "cursorarrow.click.badge.clock.fill")
                    .font(.system(size: 150))
                    .foregroundColor(.white.opacity(0.12))
                    .position(x: geo.size.width - 100, y: geo.size.height / 2)
                
                Capsule()
                    .fill(Color.white.opacity(0.10))
                    .frame(width: 500, height: 150)
                    .rotationEffect(.degrees(-30))
                    .position(x: 100, y: geo.size.height - 100)

                VStack {
                    
                    // 3. Encabezado (Volver y Marcador)
                    
                    HStack {
                        Button(action: { dismiss() }) {
                            Label("Volver", systemImage: "arrowshape.turn.up.left.fill")
                                .font(.title3)
                                .padding(12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(15)
                        }
                        .padding([.leading, .top], 30)
                        
                        Spacer()
                        
                        VStack {
                            Text("Tiempo: \(gameTimeRemaining)")
                            Text("Puntos: \(score)")
                        }
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(15)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(20)
                        .padding([.trailing, .top], 30)
                    }
                    
                    Text("¡Toca la Letra!")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5)
                    
                    Spacer()
                }
                
                // 4. El Objetivo (La Letra)
                if isTargetVisible {
                    Text("A")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.white)
                        .padding(40)
                        .background(Color.red.opacity(0.8))
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .position(targetPosition)
                        .onTapGesture {
                            score += 1
                            isTargetVisible = false
                        }
                }
                
                //  5. Pantalla de Fin de Juego
                if isGameOver {
                    VStack(spacing: 30) {
                        Text("¡Juego Terminado!")
                            .font(.system(size: 60, weight: .bold))
                        Text("Puntos Totales: \(score)")
                            .font(.largeTitle)
                        Button("Jugar de Nuevo") {
                            reiniciarJuego()
                        }
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(25)
                        .background(Color.white)
                        .cornerRadius(30)
                    }
                    .padding(60)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(30)
                    .foregroundColor(.white)
                    .transition(.scale)
                }
            }
            // 6. Conexión de los Temporizadores
            .onReceive(gameClockTimer) { _ in
                if gameTimeRemaining > 0 && !isGameOver {
                    gameTimeRemaining -= 1
                } else if gameTimeRemaining == 0 && !isGameOver {
                    withAnimation {
                        isGameOver = true
                    }
                }
            }
            .onReceive(targetTimer) { _ in
                if !isGameOver {
                    withAnimation(.spring()) {
                        moveTarget(size: geo.size)
                    }
                }
            }
            .onAppear {
                targetPosition = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            }
        }
        .navigationBarHidden(true)
    }
    
    // 7. Lógica del Juego 
    
    func moveTarget(size: CGSize) {
        let randomX = CGFloat.random(in: 100...(size.width - 100))
        let randomY = CGFloat.random(in: 200...(size.height - 200))
        
        targetPosition = CGPoint(x: randomX, y: randomY)
        isTargetVisible = true
    }
    
    func reiniciarJuego() {
        score = 0
        gameTimeRemaining = 30
        isTargetVisible = false
        withAnimation {
            isGameOver = false
        }
    }
}

struct TocaRapidoView_Previews: PreviewProvider {
    static var previews: some View {
        TocaRapidoView()
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
