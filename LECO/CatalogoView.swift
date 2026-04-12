import SwiftUI

// MARK: - Formas Personalizadas
// Dejamos tu estructura Triangle intacta por si la usas en otro lado
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
                    // 👉 AQUÍ ESTÁ EL ÚNICO CAMBIO: Reemplazamos las figuras por tu vista animada
                    FondoCuentosView()

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
                        
                        // MARK: - Lista de Cuentos (Intacta)
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
