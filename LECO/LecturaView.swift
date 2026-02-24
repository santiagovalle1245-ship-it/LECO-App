import SwiftUI

struct LecturaView: View {
    let cuento: Cuento
    @Environment(\.dismiss) var dismiss
    
    // Conectamos los motores de audio y voz
    @StateObject private var audioManager = AudioManager()
    @StateObject private var speechManager = SpeechManager()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // --- FONDO INTENSO (Estilo Pergamino) ---
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.96, green: 0.92, blue: 0.82), // Tan claro
                        Color(red: 0.9, green: 0.85, blue: 0.7)    // Tan más oscuro
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // --- DECORACIONES DE FONDO ---
                Image(systemName: "book.fill")
                    .font(.system(size: 150))
                    .foregroundColor(.black.opacity(0.08))
                    .position(x: 100, y: 120)
                
                Image(systemName: "feather")
                    .font(.system(size: 200))
                    .foregroundColor(.black.opacity(0.06))
                    .rotationEffect(.degrees(30))
                    .position(x: geo.size.width - 100, y: geo.size.height / 2)
                
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 180))
                    .foregroundColor(.black.opacity(0.07))
                    .position(x: 120, y: geo.size.height - 100)
                
                // --- CONTENIDO PRINCIPAL ---
                VStack(spacing: 0) {
                    
                    // Botón de Volver
                    HStack {
                        Button(action: {
                            // Detenemos todo al salir
                            audioManager.stopPlayback()
                            audioManager.stopRecording()
                            speechManager.detener()
                            dismiss()
                        }) {
                            Label("Volver", systemImage: "arrowshape.turn.up.left.fill")
                                .padding(12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(15)
                                .shadow(radius: 3)
                        }
                        .padding([.leading, .top], 30)
                        Spacer()
                    }
                    
                    // Área de Lectura
                    ScrollView {
                        VStack(alignment: .leading, spacing: 25) {
                            
                            // TÍTULO (Redondeado y Grueso)
                            Text(cuento.titulo)
                                .font(.system(size: 50, weight: .heavy, design: .rounded))
                                .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                            
                            // AUTOR (Redondeado y Sutil)
                            Text(cuento.autor)
                                .font(.system(size: 24, weight: .medium, design: .rounded))
                                .italic()
                                .foregroundColor(.gray)
                                .padding(.bottom, 10)
                            
                            Image(cuento.imagenPortada)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 450)
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
                                .padding(.bottom, 20)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            // TEXTO DEL CUENTO (Redondeado, Limpio y Grande)
                            Text(cuento.contenido)
                                .font(.system(size: 28, weight: .regular, design: .rounded))
                                .lineSpacing(10) // Espacio cómodo entre líneas
                                .foregroundColor(Color.black.opacity(0.85))
                            
                            Spacer().frame(height: 120)
                        }
                        .padding(60)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white.opacity(0.92))
                            .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                    )
                    .padding(EdgeInsets(top: 20, leading: 80, bottom: 40, trailing: 80))
                    
                    // --- BARRA DE HERRAMIENTAS ---
                    .overlay(alignment: .bottom) {
                        HStack(spacing: 30) {
                            
                            // 1. IZQUIERDA: Ir a la Prueba
                            NavigationLink(destination: PruebaCuentoView(cuento: cuento)) {
                                HStack {
                                    Image(systemName: "brain.head.profile")
                                        .font(.system(size: 30))
                                    Text("Prueba")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                }
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(30)
                                .shadow(radius: 5)
                            }
                            
                            Spacer()
                            
                            // 2. CENTRO: IA Lector de Voz
                            Button(action: {
                                if speechManager.isSpeaking {
                                    speechManager.detener()
                                } else {
                                    speechManager.leerCuento(texto: cuento.contenido)
                                }
                            }) {
                                HStack {
                                    Image(systemName: speechManager.isSpeaking ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                        .font(.system(size: 30))
                                    Text(speechManager.isSpeaking ? "Silencio" : "Leer")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                }
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(30)
                                .shadow(radius: 5)
                            }
                            
                            Spacer()
                            
                            // 3. DERECHA: Grabadora
                            HStack(spacing: 20) {
                                if audioManager.isRecording {
                                    Button(action: { audioManager.stopRecording() }) {
                                        HStack {
                                            Image(systemName: "stop.circle.fill").font(.system(size: 40))
                                            Text("Detener").fontWeight(.bold)
                                        }
                                        .padding().background(Color.red).foregroundColor(.white).cornerRadius(30).shadow(radius: 5)
                                    }
                                } else {
                                    Button(action: { audioManager.startRecording() }) {
                                        HStack {
                                            Image(systemName: "mic.circle.fill").font(.system(size: 40))
                                            Text("Grabar").fontWeight(.bold)
                                        }
                                        .padding().background(Color.red).foregroundColor(.white).cornerRadius(30).shadow(radius: 5)
                                    }
                                }
                                
                                if audioManager.recordingExists && !audioManager.isRecording {
                                    Button(action: {
                                        if audioManager.isPlaying { audioManager.stopPlayback() } else { audioManager.startPlayback() }
                                    }) {
                                        HStack {
                                            Image(systemName: audioManager.isPlaying ? "stop.fill" : "play.circle.fill").font(.system(size: 40))
                                            Text(audioManager.isPlaying ? "Detener" : "Oírme") .fontWeight(.bold)
                                        }
                                        .padding().background(Color.blue).foregroundColor(.white).cornerRadius(30).shadow(radius: 5)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 60)
                        .padding(.bottom, 50)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onDisappear {
            audioManager.stopPlayback()
            audioManager.stopRecording()
            speechManager.detener()
        }
    }
}

struct LecturaView_Previews: PreviewProvider {
    static var previews: some View {
        LecturaView(cuento: listaDeCuentos[0])
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
