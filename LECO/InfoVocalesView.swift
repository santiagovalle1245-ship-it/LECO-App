import SwiftUI

struct InfoVocalesView: View {
    @Environment(\.dismiss) var dismiss
    
    // Datos para mostrar ejemplos
    let datosVocales = [
        ("A", "Árbol", "🌳", Color.red),
        ("E", "Estrella", "🌟", Color.orange),
        ("I", "Isla", "🏝️", Color.yellow),
        ("O", "Oso", "🐻", Color.blue),
        ("U", "Uva", "🍇", Color.purple)
    ]
    
    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.98, blue: 1.0).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("¿Qué son las Vocales?")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.blue)
                    .padding(.top, 30)
                
                Text("Son las letras que le dan sonido a las palabras.\n¡Hay 5 vocales y son muy importantes!")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .foregroundColor(.black.opacity(0.7))
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(datosVocales, id: \.0) { vocal in
                            HStack {
                                Text(vocal.0)
                                    .font(.system(size: 60, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 80, height: 80)
                                    .background(vocal.3)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading) {
                                    Text(vocal.1)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(vocal.3)
                                    Text("Como en \(vocal.1)")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text(vocal.2).font(.system(size: 50))
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                        }
                    }
                    .padding(20)
                }
                
                Button(action: { dismiss() }) {
                    Text("¡Entendido!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .padding(30)
            }
        }
    }
}

struct InfoVocalesView_Previews: PreviewProvider {
    static var previews: some View {
        InfoVocalesView()
    }
}
