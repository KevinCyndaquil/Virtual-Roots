//
//  SimulacionHome.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 04/03/24.
//

import Foundation
import SwiftUI

struct ListPlantsUI: View {
    private var virtualBold = "PlusJakartaSans-Regular_Bold"
    private var virtualLight = "PlusJakartaSans-Regular_Light"
    @StateObject var listPlantsViewModel = PlantsListViewModel()
    @ObservedObject var plantsViewModel : PlantsViewModel
    @State private var showMaxText = true
    @Binding var navigationPath: NavigationPath
    
    public init(navigationPath: Binding<NavigationPath>, plantsViewModel: PlantsViewModel) {
            _navigationPath = navigationPath
            self.plantsViewModel = plantsViewModel
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
                        plantsViewModel.plantsFavorite = listPlantsViewModel.getCheckedPlants();
                    }
                    HStack(alignment: .center, spacing: 10) {  }
                        .padding(.horizontal, 0)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, minHeight: 43, maxHeight: 43, alignment: .center)
                    HStack(alignment: .center, spacing: 10) {
                        Image("searchMin")
                            .frame(width: 50, height: 50.00977)
                        
                    }
                    .padding(10)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .center)
                HStack(alignment: .center, spacing: 10) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Plants")
                            .font(
                                Font.custom(virtualBold, size: 36)
                            )
                            .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04))
                        Text("Select the plants to add")
                            .font(
                                Font.custom(virtualLight, size: 24)
                            )
                            .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04).opacity(0.5))
                        if(listPlantsViewModel.isMaximum){
                            if showMaxText {
                                    Text("Max 6")
                                        .font(Font.custom("VirtualLight", size: 18))
                                        .foregroundColor(.red)
                                        // Cuando se muestra, espera 3 segundos y luego oculta
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                showMaxText = false
                                            }
                                        }
                                }
                            
                        }
                        
                    }
                    .padding(.horizontal, 0)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .center)
                ScrollView{
                    VStack(alignment: .center, spacing: 10) {
                        ForEach(listPlantsViewModel.listPlants.indices , id: \.self){ index in
                            HStack(alignment: .center, spacing: 10) {
                                VStack(alignment: .center, spacing: 0) {
                                    VStack(alignment: .center, spacing: 0) {
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 64, height: 64)
                                            .background(
                                                Image(listPlantsViewModel.listPlants[index].image)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 64, height: 64)
                                                    .clipped()
                                            )
                                    }
                                    .padding(10)
                                    .background(Color(red: 0.38, green: 0.56, blue: 0.13))
                                    .cornerRadius(60)
                                    
                                }
                                .padding(10)
                                .background(Color(red: 0.38, green: 0.56, blue: 0.13))
                                .cornerRadius(60)
                                HStack(alignment: .center, spacing: 10) {
                                    Text(listPlantsViewModel.listPlants[index].name)
                                        .font(Font.custom("Plus Jakarta Sans", size: 29))
                                        .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04))
                                }
                                .padding(.horizontal, 30)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if(listPlantsViewModel.listPlants[index].isChecked){
                                    HStack(alignment: .center, spacing: 10) {
                                        Toggle(listPlantsViewModel.listPlants[index].name, isOn:
                                                $listPlantsViewModel.listPlants[index].isChecked
                                        )
                                        .toggleStyle(CheckBoxToggleStyle())
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                }
                                
                            }
                            .padding(.horizontal, 40)
                            .padding(.top, 5)
                            .padding(.bottom, 10)
                            .contentShape(Rectangle())
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(listPlantsViewModel.listPlants[index].isChecked ? Color(red: 0.83, green: 0.93, blue: 0.66) : Color.clear)
                            .cornerRadius(30)
                            .onTapGesture{
                                listPlantsViewModel.checked(index: index)
                                print("HStack tocado!")
                            }
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    
                }
                
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 34)
            .frame(maxWidth: .infinity, minHeight: 1036, maxHeight: 1036, alignment: .topLeading)
            NavBar()
        }
        .padding(0)
        .frame(width: 834, alignment: .center)
        .background(Color(red: 0.96, green: 0.98, blue: 0.92))
        .toolbar(.hidden)
    }
    
    
}

struct CheckBoxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack{
            RoundedRectangle(cornerRadius: 2.0)
                .stroke(Color(red: 0.2, green: 0.29, blue: 0.11), lineWidth: 3)
                .frame(width: 32, height: 32)
                .overlay{
                    Image(systemName: configuration.isOn ? "checkmark" : "")
                }
                .onTapGesture {
                    withAnimation{
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}



