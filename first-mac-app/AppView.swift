//
//  AppView.swift
//  first-mac-app
//
//  Created by mostafa on 18.09.26.
//

import SwiftUI

struct AppView: View {
    @AppStorage("isAuth") private var isAuth: Bool = false
    
    
    var body: some View {
        VStack {
            /*Button("Login"){
                if(isAuth){
                    isAuth = false
                }else{
                    isAuth = true
                }
            }*/
            if(isAuth){
                HomeView()
            }else{
                LoginView()
            }
        }
    }
}
