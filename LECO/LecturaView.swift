import SwiftUI

struct LecturaView: View {
    let cuento: Cuento
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var audioManager = AudioManager()
    @StateObject private var speechManager = SpeechManager()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                FondoLecturaView()
                
                VStack(spacing: 0) {
                    
                    // --- BOTÓN DE VOLVER ---
                    HStack {
                        Button(action: {
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
                                .foregroundColor(.black)
                        }
                        .padding([.leading, .top], 30)
                        Spacer()
                    }
                    
                    // --- ÁREA DE LECTURA INMERSIVA CON AUTO-SCROLL ---
                    // Envolvemos el ScrollView con el Elevadorista (ScrollViewReader)
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(alignment: .center, spacing: 30) {
                                
                                Text(cuento.titulo)
                                    .font(.system(size: 55, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .shadow(color: .black.opacity(0.3), radius: 5, y: 3)
                                
                                Text(cuento.autor)
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.bottom, 10)
                                
                                Image(cuento.imagenPortada)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 350)
                                    .cornerRadius(25)
                                    .shadow(color: .black.opacity(0.4), radius: 15, y: 8)
                                    .padding(.bottom, 30)
                                
                                // --- TEXTO DEL CUENTO EN BLOQUES DE LEGO (Renglones) ---
                                // 1. Cortamos el cuento en oraciones (usando el punto)
                                let renglones = cuento.contenido.components(separatedBy: ".")
                                // 2. Llevamos una cuenta paralela de cuántas palabras van en total
                                // para no perder la sincronización del color
                                var contadorPalabrasAcumuladas = 0
                                
                                // 3. Dibujamos cada renglón por separado
                                ForEach(0..<renglones.count, id: \.self) { indexRenglon in
                                    let renglon = renglones[indexRenglon]
                                    
                                    // Evitamos dibujar renglones vacíos si hay un punto al final del cuento
                                    if !renglon.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                        
                                        let palabrasDelRenglon = renglon.split(separator: " ")
                                        
                                        // Dibujamos el renglón
                                        Text(crearTextoRenglon(
                                            palabras: palabrasDelRenglon,
                                            indicePalabraActiva: speechManager.indicePalabraActual,
                                            palabrasAcumuladas: contadorPalabrasAcumuladas
                                        ))
                                        .multilineTextAlignment(.leading)
                                        .lineSpacing(15)
                                        .id(indexRenglon) // ¡AQUÍ LE PONEMOS EL GAFETE AL RENGLÓN!
                                        
                                        // Sumamos las palabras de este renglón para el siguiente ciclo
                                        let _ = (contadorPalabrasAcumuladas += palabrasDelRenglon.count)
                                    }
                                }
                                
                                Spacer().frame(height: 150)
                            }
                            .padding(.horizontal, 40)
                            .padding(.top, 20)
                        }
                        // LA MAGIA: Le decimos al Elevadorista que escuche el radio del renglón
                        .onChange(of: speechManager.indiceRenglonActual) { nuevoRenglon in
                            // Si el renglón es mayor a 0, haz scroll suave hacia ese gafete
                            if nuevoRenglon >= 0 {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    // Anclamos el renglón al centro de la pantalla (.center)
                                    proxy.scrollTo(nuevoRenglon, anchor: .center)
                                }
                            }
                        }
                    }
                    // --- FIN ÁREA LECTURA ---
                    
                    // --- BARRA DE HERRAMIENTAS (Se queda igual) ---
                    .overlay(alignment: .bottom) {
                        HStack(spacing: 30) {
                            NavigationLink(destination: PruebaCuentoView(cuento: cuento)) {
                                HStack {
                                    Image(systemName: "brain.head.profile").font(.system(size: 30))
                                    Text("Prueba").font(.title3).fontWeight(.bold)
                                }
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(30)
                                .shadow(radius: 5)
                            }
                            Spacer()
                            Button(action: {
                                if speechManager.isSpeaking {
                                    speechManager.detener()
                                } else {
                                    speechManager.leerCuento(texto: cuento.contenido)
                                }
                            }) {
                                HStack {
                                    Image(systemName: speechManager.isSpeaking ? "speaker.slash.fill" : "speaker.wave.2.fill").font(.system(size: 30))
                                    Text(speechManager.isSpeaking ? "Silencio" : "Leer").font(.title3).fontWeight(.bold)
                                }
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(30)
                                .shadow(radius: 5)
                            }
                            Spacer()
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
    
    // --- FUNCIÓN MOTOR DE TEXTO (Ligeramente ajustada para trabajar por renglón) ---
    func crearTextoRenglon(palabras: [String.SubSequence], indicePalabraActiva: Int, palabrasAcumuladas: Int) -> AttributedString {
        var textoFinal = AttributedString("")
        
        for (indexLocal, palabra) in palabras.enumerated() {
            // Re-agregamos el punto que le quitamos al separar los renglones (si es la última palabra)
            let esUltimaPalabra = (indexLocal == palabras.count - 1)
            let textoPalabra = String(palabra) + (esUltimaPalabra ? ". " : " ")
            
            var palabraAtributos = AttributedString(textoPalabra)
            
            // Calculamos el índice global de la palabra en todo el cuento
            let indexGlobal = palabrasAcumuladas + indexLocal
            
            if indexGlobal == indicePalabraActiva {
                palabraAtributos.foregroundColor = .white
                palabraAtributos.font = .system(size: 46, weight: .black, design: .rounded)
            } else {
                palabraAtributos.foregroundColor = .white.opacity(0.35)
                palabraAtributos.font = .system(size: 38, weight: .bold, design: .rounded)
            }
            
            textoFinal.append(palabraAtributos)
        }
        return textoFinal
    }
}

struct LecturaView_Previews: PreviewProvider {
    static var previews: some View {
        LecturaView(cuento: listaDeCuentos[0])
            .previewDevice("iPad Pro (12.9-inch)")
    }
}

