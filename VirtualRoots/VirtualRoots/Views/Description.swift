//
//  SimulacionHome.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 04/03/24.
//

import Foundation
import SwiftUI

struct Description: View {
    private var virtualBold = "PlusJakartaSans-Regular_Bold"
    private var virtualLight = "PlusJakartaSans-Regular_Light"
    var model: Plant
    @Binding var navigationPath: NavigationPath
    
    public init(navigationPath: Binding<NavigationPath>, model: Plant) {
        _navigationPath = navigationPath
        self.model = model
    }
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 10) {
                    HStack(alignment: .center, spacing: 10) {
                        Image("flechasalir")
                            .frame(width: 58.3073, height: 50)
                        
                    }
                    .padding(10)
                    .onTapGesture {
                        navigationPath.removeLast()
                    }
                    HStack(alignment: .center, spacing: 10) {  }
                        .padding(.horizontal, 0)
                        .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, minHeight: 43, maxHeight: 43, alignment: .center)}
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .center)
                VStack(alignment: .center, spacing: 10) {
                    VStack(alignment: .center, spacing: 10) {
                        Text(model.name)
                            .font(Font.custom("Finger Paint", size: 48))
                            .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04))
                    }
                    .padding(.horizontal, 0)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                    HStack(alignment: .top, spacing: 10) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(model.scientific_name)
                                .font(
                                    Font.custom("Plus Jakarta Sans", size: 20)
                                        .weight(.light)
                                )
                                .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04).opacity(0.5))
                            Text(model.description)
                                .font(
                                    Font.custom("Plus Jakarta Sans", size: 24)
                                        .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04).opacity(0.5))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        .padding(0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        HStack(alignment: .center, spacing: 10) {
                            HStack(alignment: .center, spacing: 10) {
                                Image(model.temperature_img)
                                    .frame(width: 39.375, height: 70)
                            }
                            .padding(.horizontal, 19)
                            .padding(.vertical, 0)
                            .frame(width: 90, height: 90, alignment: .center)
                            
                            .background(Color(red: 0.96, green: 0.98, blue: 0.92))
                            .cornerRadius(175)
                            .overlay(
                                RoundedRectangle(cornerRadius: 175)
                                    .inset(by: 0.5)
                                    .stroke(Color(red: 0.2, green: 0.29, blue: 0.11), lineWidth: 1)
                            )
                            HStack(alignment: .center, spacing: 10) {
                                Image(systemName: "sun.min.fill")
                                    .foregroundColor(Color(red: 0.87, green: 0.75, blue: 0.12))
                                    .font(.system(size: 55))
                                    .frame(width: 90, height: 90)
                            }
                            .padding(.horizontal, 19)
                            .padding(.vertical, 0)
                            .frame(width: 90, height: 90, alignment: .center)
                            .background(Color(red: 0.96, green: 0.98, blue: 0.92))
                            .cornerRadius(175)
                            .overlay(
                                RoundedRectangle(cornerRadius: 175)
                                    .inset(by: 0.5)
                                    .stroke(Color(red: 0.2, green: 0.29, blue: 0.11), lineWidth: 1)
                            )
                            HStack(alignment: .center, spacing: 10) {
                                Image("franco")
                                    .frame(width: 90, height: 90)
                            }
                            .padding(.horizontal, 19)
                            .padding(.vertical, 0)
                            .frame(width: 90, height: 90, alignment: .center)
                            .background(.black.opacity(0.2))
                            .background(Color(red: 0.91, green: 0.96, blue: 0.82))
                            .cornerRadius(175)
                            .overlay(
                                RoundedRectangle(cornerRadius: 175)
                                    .inset(by: 0.5)
                                    .stroke(Color(red: 0.2, green: 0.29, blue: 0.11), lineWidth: 1)
                            )
                        }
                        .padding(0)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal, 0)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .top)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 0)
                .frame(maxWidth: .infinity, alignment: .center)
                VStack(alignment: .leading, spacing: 10) {
                    ScrollView{
                        //aqui irna 4
                        ForEach(model.etapas.indices, id: \.self) { index in
                            HStack(alignment: .center, spacing: 50) {
                                VStack(alignment: .center, spacing: 10) {
                                    HStack(alignment: .center, spacing: 40) {
                                        Text("Stage \(model.etapas[index].id)")
                                            .font(
                                                Font.custom(virtualBold, size: 24)
                                            )
                                            .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04).opacity(0.5))
                                    }
                                    .padding(10)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    HStack(alignment: .center, spacing: 40) {
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 151, height: 164)
                                            .background(
                                                Image(model.etapas[index].imagen)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 151, height: 164)
                                                    .clipped()
                                            )
                                        Image("flecha")
                                            .frame(width: 83, height: 60)
                                    }
                                    .padding(10)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .top)
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack(alignment: .center, spacing: 20) {
                                        HStack(alignment: .center, spacing: 10) {
                                            Image("water")
                                                .frame(width: 40, height: 53.33333)
                                        }
                                        .padding(.horizontal, 19)
                                        .padding(.vertical, 0)
                                        .frame(width: 90, height: 90, alignment: .center)
                                        .background(.black.opacity(0.2))
                                        .background(Color(red: 0.91, green: 0.96, blue: 0.82))
                                        .cornerRadius(175)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 175)
                                                .inset(by: 0.5)
                                                .stroke(Color(red: 0.2, green: 0.29, blue: 0.11), lineWidth: 1)
                                        )
                                        Text(model.etapas[index].water)
                                            .font(
                                                Font.custom("Plus Jakarta Sans", size: 20)
                                                    .weight(.light)
                                            )
                                            .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04).opacity(0.5))
                                            .frame(width: 178, alignment: .topLeading)
                                    }
                                    .padding(10)
                                    HStack(alignment: .center, spacing: 20) {
                                        HStack(alignment: .center, spacing: 10) {
                                            Image("abono")
                                                .frame(width: 71.21212, height: 70)
                                        }
                                        .padding(.horizontal, 19)
                                        .padding(.vertical, 0)
                                        .frame(width: 90, height: 90, alignment: .center)
                                        .background(.black.opacity(0.2))
                                        .background(Color(red: 0.91, green: 0.96, blue: 0.82))
                                        .cornerRadius(175)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 175)
                                                .inset(by: 0.5)
                                                .stroke(Color(red: 0.2, green: 0.29, blue: 0.11), lineWidth: 1)
                                        )
                                        Text("Biofertilization")
                                            .font(
                                                Font.custom("Plus Jakarta Sans", size: 20)
                                                    .weight(.light)
                                            )
                                            .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04).opacity(0.5))
                                            .frame(width: 178, alignment: .topLeading)
                                    }
                                    .padding(10)
                                    HStack(alignment: .center, spacing: 20) {
                                        HStack(alignment: .center, spacing: 10) {
                                            Image("abono")
                                                .frame(width: 71.21212, height: 70)
                                        }
                                        .padding(.horizontal, 19)
                                        .padding(.vertical, 0)
                                        .frame(width: 90, height: 90, alignment: .center)
                                        .background(.black.opacity(0.2))
                                        .background(Color(red: 0.91, green: 0.96, blue: 0.82))
                                        .cornerRadius(175)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 175)
                                                .inset(by: 0.5)
                                                .stroke(Color(red: 0.2, green: 0.29, blue: 0.11), lineWidth: 1)
                                        )
                                        Text("plagas")
                                            .font(
                                                Font.custom("Plus Jakarta Sans", size: 20)
                                                    .weight(.light)
                                            )
                                            .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04).opacity(0.5))
                                            .frame(width: 178, alignment: .topLeading)
                                    }
                                    .padding(10)
                                }
                                .padding(10)
                                .frame(maxHeight: .infinity, alignment: .leading)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .inset(by: 0.5)
                                        .stroke(Color(red: 0.72, green: 0.88, blue: 0.46), lineWidth: 1)
                                )
                            }
                            .padding(.horizontal, 0)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 34)
            .frame(maxWidth: .infinity, minHeight: 1036, maxHeight: 1036, alignment: .topLeading)
            NavBar(navigationPath: $navigationPath)
            
        }
        .padding(0)
        .frame(width: 834, alignment: .center)
        .background(Color(red: 0.96, green: 0.98, blue: 0.92))
        .toolbar(.hidden)
        
    }
}





