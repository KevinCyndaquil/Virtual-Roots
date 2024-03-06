//
//  AppDelegate.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 01/03/24.
//

import SwiftUI

@main
struct AppDelegate: App {
    init() {
        registerFonts()
    }
    func registerFonts() {
        let fontNames = ["FingerPaint-Regular", "PlusJakartaSans-VariableFont_wght"] // Añade tus nombres de fuentes aquí
        let fontExtension = "ttf" // o "otf" dependiendo de tus archivos de fuente

        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: fontExtension) {
                CTFontManagerRegisterFontsForURL(fontURL as CFURL, CTFontManagerScope.process, nil)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
