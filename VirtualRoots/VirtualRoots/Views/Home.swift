//
//  Home.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 04/03/24.
//

import Foundation
import SwiftUI

struct HomeUI: View {
    @State private var rotation = 0.0
    @State private var showNextView = false
    @State private var navigationPath = NavigationPath()
    var body: some View {
        NavigationStack(path: $navigationPath){
            // Agrega los elementos SwiftUI que quieras aquí
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
                    Text("Virtual\nRoots")
                        .font(Font.custom("Finger Paint", size: 64))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 34)
                .frame(maxHeight: .infinity, alignment: .center)
                VStack(alignment: .center, spacing: 0) {
                    Image("loading")
                        .frame(width: 124, height: 124)
                        .rotationEffect(.degrees(rotation))
                        .onAppear {
                            // Esta animación hará que la imagen rote continuamente.
                            withAnimation(Animation.linear(duration: 4).repeatForever(autoreverses: false)) {
                                rotation = 360
                            }
                            // Programar la llamada al método después de 2 segundos
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.62) {
                                navigationPath.append(1)
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
            .navigationDestination(for: Int.self){ value in
                switch value {
                    case 1:
                    SimulationHomeUI(navigationPath: $navigationPath)
                    default:
                        HomeUI() // Para cualquier valor entero no reconocido
                    }
            }
        }
        
    }
}
