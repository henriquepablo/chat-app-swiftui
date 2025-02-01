//
//  ContentView.swift
//  SwiftUIChatApp
//
//  Created by pablo henrique on 01/02/25.
//

import SwiftUI

struct LoginView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var Password = ""
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Picker ("Picker here", selection: $isLoginMode) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    if (!isLoginMode) {
                        Button {
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
 
                        SecureField("Password", text: $Password)

                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(5)
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .font(.system(size: 14, weight: .semibold))
                            
                            Spacer()
                        }
                        .background(Color.blue)
                        .cornerRadius(5)

                    }
                }
                .padding()
            }
            .background(Color(.init(white: 0, alpha: 0.05)))
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            
        }
    }
    
    private func handleAction() {
        if (isLoginMode) {
            print("Should log into Firebas with existing credentials")
        } else {
            print("Register a new account inside of Firebase Auth and then store image in Storage somehow...")
        }
    }
}

#Preview {
    LoginView()
}
