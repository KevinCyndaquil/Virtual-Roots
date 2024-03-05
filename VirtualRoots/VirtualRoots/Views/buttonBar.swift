//
//  buttonBar.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 04/03/24.
//

import Foundation
import SwiftUI

struct NavBar : View {
    var body : some View {
        HStack(alignment: .center, spacing: 10) {
            HStack(alignment: .center, spacing: 0) {
                Image("search")
                  .frame(width: 90, height: 90)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 0)
            .frame(maxWidth: .infinity, alignment: .trailing)
            HStack(alignment: .center, spacing: 0) {
                Image(systemName: "camera.aperture")
                    .foregroundColor(Color(red: 0.24, green: 0.35, blue: 0.11))
                    .font(.system(size: 95))
                  .frame(width: 80, height: 70.76923)
                  
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 30)
            .frame(width: 128, alignment: .center)
            .background(Color(red: 0.96, green: 0.98, blue: 0.92))
            .cornerRadius(40)
            .overlay(
              RoundedRectangle(cornerRadius: 40)
                .inset(by: 2.5)
                .stroke(Color(red: 0.24, green: 0.35, blue: 0.11), lineWidth: 5)
            )
            HStack(alignment: .center, spacing: 0) {
                Image("stats")
                  .frame(width: 90, height: 90)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 0)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
            .padding(.horizontal, 10)
            .padding(.top, 10)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, alignment: .center)
            .overlay(
                Rectangle()
                    .inset(by: 1)
                    .stroke(Color(red: 0.29, green: 0.43, blue: 0.11), lineWidth: 2)
            )
    }
}
