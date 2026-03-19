import SwiftUI

// MARK: - Formas Personalizadas
// Crea una forma de triángulo para las decoraciones del fondo
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct CatalogoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    
                    // MARK: - Fondo y Decoraciones
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.4, green: 0.3, blue: 0.7).opacity(0.8),
                            Color(red: 0.2, green: 0.2, blue: 0.5).opacity(0.9)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    Circle()
                        .fill(Color.white.opacity(0.20))
                        .frame(width: 500, height: 500)
                        .position(x: 80, y: 150)
                    
                    Triangle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 400, height: 400)
                        .rotationEffect(.degrees(180))
                        .position(x: geo.size.width - 150, y: geo.size.height - 150)

                    Circle()
                        .fill(Color.white.opacity(0.18))
                        .frame(width: 300, height: 300)
                        .position(x: geo.size.width - 100, y: 100)
                    
                    Triangle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 150, height: 150)
                        .rotationEffect(.degrees(-30))
                        .position(x: 100, y: geo.size.height - 200)

                    // MARK: - Encabezado
                    VStack {
                        HStack {
                            Button(action: { dismiss() }) {
                                Label("Volver", systemImage: "arrowshape.turn.up.left.fill")
                                    .padding(10)
                                    .background(Color.white.opacity(0.7))
                                    .cornerRadius(12)
                                    .shadow(radius: 2)
                            }
                            // ACCESIBILIDAD
                            .accessibilityLabel("Volver al menú principal")
                            .accessibilityHint("Toca dos veces para salir del catálogo")
                            .padding(.leading)
                            
                            Spacer()
                        }
                        
                        Text("Biblioteca de Cuentos")
                            .font(.system(size: 60, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.4), radius: 5)
                            .padding(.bottom, 20)
                        
                        // MARK: - Lista de Cuentos
                        // Recorre la lista de cuentos y crea una tarjeta para cada uno
                        List {
                            ForEach(listaDeCuentos, id: \.id) { cuento in
                                NavigationLink(destination: LecturaView(cuento: cuento)) {
                                    HStack(spacing: 20) {
                                        Image(cuento.imagenPortada)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(15)
                                            .shadow(radius: 5)
                                        
                                        VStack(alignment: .leading) {
                                            Text(cuento.titulo)
                                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                                .foregroundColor(.black)
                                            Text(cuento.autor)
                                                .font(.system(size: 18, design: .rounded))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.leading, 10)
                                        Spacer()
                                    }
                                    .padding()
                                    // ACCESIBILIDAD
                                    // Combine une la imagen, titulo y autor en un solo elemento de audio para el lector
                                    .accessibilityElement(children: .combine)
                                    .accessibilityLabel("Cuento: \(cuento.titulo), Autor: \(cuento.autor)")
                                    .accessibilityHint("Toca dos veces para empezar a leer este cuento")
                                }
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white.opacity(0.95))
                                        .padding(.vertical, 8)
                                        .shadow(color: .black.opacity(0.15), radius: 4, y: 3)
                                )
                                .listRowSeparator(.hidden)
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}

struct CatalogoView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogoView()
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
