//
//  Main.swift
//  reversy
//
//  Created by Никита Смирнов on 03.11.2024.
//

import SwiftUI

struct MainS: View {
    @StateObject var mainLogic = MainLogic()
    
    var body: some View {
        ContentView()
            .environmentObject(mainLogic)
    }
}

#Preview {
    MainS()
}
