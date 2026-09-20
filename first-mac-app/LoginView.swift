//
//  LoginView.swift
//  first-mac-app
//
//  Created by mostafa on 18.09.26.
//

import SwiftUI

struct LoginView: View {
    @AppStorage("isAuth") private var isAuth: Bool = false
    
    @State private var email = ""
    @State private var password = ""
    
    
    
    private func loginAction() {
        if(email != "" && password != ""){
            isAuth = true
        }
        
    }
    
    
    
    var body: some View {
        VStack {
           
            
            Text("Login")
                .font(.largeTitle)
                .bold()
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            Button(action: loginAction){
                Text("Login")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
            }
                
            
            
            
            
            
            
        }
        .padding()
    }
}
/*
#Preview {
    LoginView()
}
*/
