//
//  SimulacionHome.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 04/03/24.
//

import Foundation
import SwiftUI


struct SimulationHomeUI: View {
    private var virtualBold = "PlusJakartaSans-Regular_Bold"
    private var virtualLight = "PlusJakartaSans-Regular_Light"
    @StateObject var plantsViewModel = PlantsViewModel()
    @State private var showingAddPlants = false
    
    var body: some View {
        // Agrega los elementos SwiftUI que quieras aquí
        VStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 10) {
                    HStack(alignment: .center, spacing: 10) {
                        Image("hoja")
                            .frame(width: 60, height: 60)
                    }
                    .padding(10)
                    HStack(alignment: .center, spacing: 10) {
                        Text("Virtual Roots")
                            .font(
                                Font.custom(virtualBold, size: 36)
                            )
                            .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04))
                    }
                    .padding(.horizontal, 0)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                    HStack(alignment: .center, spacing: 10) {
                        Image("ruedita")
                            .frame(width: 53.14571, height: 53.14571)
                    }
                    .padding(10)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .center)
                HStack(alignment: .center, spacing: 10) {
                    HStack(alignment: .center, spacing: 10) {
                        Text("Today's Weather")
                            .font(
                                Font.custom(virtualBold, size: 32)
                            )
                            .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04))
                    }
                    .padding(.horizontal, 0)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .center)
                HStack(alignment: .center, spacing: 12) {
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 0) {
                            Image("sol")
                                .frame(width: 24, height: 24)
                            
                        }
                        .padding(0)
                        .frame(width: 139, height: 24, alignment: .leading)
                        VStack(alignment: .leading, spacing: 4) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("San Francisco")
                                    .font(
                                        Font.custom(virtualBold, size: 16)
                                    )
                                    .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04))
                            }
                            .padding(0)
                            .frame(width: 139, height: 20, alignment: .topLeading)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Sunny")
                                    .font(Font.custom("Plus Jakarta Sans", size: 14))
                                    .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04))
                            }
                            .padding(0)
                            .frame(width: 139, height: 21, alignment: .topLeading)
                        }
                        .padding(0)
                        .frame(width: 139, height: 45, alignment: .topLeading)
                    }
                    .padding(16)
                    .frame(width: 173, height: 115, alignment: .topLeading)
                    .background(.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 1)
                            .stroke(Color(red: 0.72, green: 0.88, blue: 0.46), lineWidth: 2)
                    )
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 0) {
                            Image("temperatura")
                                .frame(width: 24, height: 24)
                        }
                        .padding(0)
                        .frame(width: 139, height: 24, alignment: .topLeading)
                        VStack(alignment: .leading, spacing: 4) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Tomorrow")
                                    .font(
                                        Font.custom(virtualBold, size: 16)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04))
                            }
                            .padding(0)
                            .frame(width: 139, height: 20, alignment: .topLeading)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("High 77, Low 50")
                                    .font(Font.custom("Plus Jakarta Sans", size: 14))
                                    .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04))
                            }
                            .padding(0)
                            .frame(width: 139, height: 21, alignment: .topLeading)
                        }
                        .padding(0)
                        .frame(width: 139, height: 45, alignment: .topLeading)
                    }
                    .padding(16)
                    .frame(width: 173, height: 115, alignment: .topLeading)
                    .background(.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 1)
                            .stroke(Color(red: 0.72, green: 0.88, blue: 0.46), lineWidth: 2)
                    )
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
                HStack(alignment: .center, spacing: 10) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Plant Care")
                            .font(
                                Font.custom(virtualBold, size: 24)
                            )
                            .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04))
                        Text("Add your favorite plants to care  for")
                            .font(
                                Font.custom(virtualLight, size: 24)
                            )
                            .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04).opacity(0.5))
                    }
                    .padding(.horizontal, 0)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 40)
                .padding(.top, 10)
                .padding(.bottom, 0)
                .frame(maxWidth: .infinity, alignment: .center)
                HStack(alignment: .center, spacing: 10) {
                    HStack(alignment: .center, spacing: 10) {
                        Image("cruz")
                            .frame(width: 32, height: 32)
                    }
                    .padding(15)
                    .background(Color(red: 0.6, green: 0.81, blue: 0.28))
                    .cornerRadius(15)
                    .onTapGesture{
                        showingAddPlants = true
                    }
                    
                    
                    HStack(alignment: .center, spacing: 10) {
                        Text("Add plant")
                            .font(Font.custom("Plus Jakarta Sans", size: 24))
                            .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04))
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(alignment: .center, spacing: 10) {
                        Image("flechaDerecha")
                            .frame(width: 20.56857, height: 36)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
                .padding(.horizontal, 40)
                .padding(.top, 5)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, alignment: .center)
                ScrollView{
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 10) {
                        ForEach(plantsViewModel.plantsFavorite, id: \.id) { model in
                            VStack(alignment: .leading, spacing: 12) {
                                VStack(alignment: .center, spacing: 0) {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 150, height: 150)
                                        .background(
                                            Image("maiz")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 150, height: 150)
                                                .clipped()
                                        )
                                }
                                .padding(10)
                                .frame(width: 170, height: 170, alignment: .center)
                                .background(Color(red: 0.24, green: 0.35, blue: 0.11))
                                .cornerRadius(34)
                                VStack(alignment: .center, spacing: 0) {
                                    Text(model.name)
                                        .font(
                                            Font.custom(virtualBold, size: 20)
                                        )
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04))
                                        .frame(maxWidth: .infinity, alignment: .top)
                                }
                                .padding(0)
                                .frame(width: 173, alignment: .top)
                            }
                            .padding(10)
                            .background(Color.gray)
                            .cornerRadius(10)
                        }
                    }
                    .padding(10)
                }
                
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 34)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            NavBar()
        }
        .padding(0)
        .frame(width: 834, height: 1194, alignment: .center)
        .background(Color(red: 0.96, green: 0.98, blue: 0.92))
        .fullScreenCover(isPresented: $showingAddPlants, content: {
            ListPlantsUI(plantsViewModel: plantsViewModel, showing: showingAddPlants)
        })
    }
}


