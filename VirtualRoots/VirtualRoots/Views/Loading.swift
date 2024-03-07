//
//  Loading.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 06/03/24.
//

import Foundation
import SwiftUI

struct LoadingUI: View {
    @State private var progress = 0.0
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // Timer que incrementa el progreso cada segundo
    var body: some View {
            VStack(alignment: .center, spacing: 0) {
                VStack(alignment: .center, spacing: 60) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 400, height: 306.53537)
                        .background(
                            Image("logo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 400, height: 306.5353698730469)
                                .clipped()
                        )
                    Text("welcome to \nvirtual reality")
                        .font(Font.custom("Finger Paint", size: 64))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 34)
                .frame(maxHeight: .infinity, alignment: .center)
                VStack(alignment: .center, spacing: 0) {
                    ProgressView(value: progress, total: 1.0)
                               .progressViewStyle(LinearProgressViewStyle())
                               .frame(width: 607, height: 20)
                               .onReceive(timer) { _ in
                                                   if progress < 1.0 { // Asegúrate de que el progreso no exceda 1.0
                                                       progress += 0.1
                                                   } else {
                                                       timer.upstream.connect().cancel() // Detiene el temporizador si el progreso es completo
                                                   }
                                               }
                }
                .padding(.horizontal, 10)
                .padding(.top, 0)
                .padding(.bottom, 104)
            }
            .padding(0)
            .frame(width: 834, height: 1194, alignment: .center)
            .background(Color(red: 0.91, green: 0.96, blue: 0.82))
            .toolbar(.hidden)
    }
}
