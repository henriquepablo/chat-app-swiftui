//
//  MainMessagesView.swift
//  SwiftUIChatApp
//
//  Created by pablo henrique on 09/02/25.
//

import SwiftUI

struct MainMessagesView: View {
    
    @State private var shouldShowLogoutOptions = false
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            
            Image(systemName: "person.fill")
                .font(.system(size: 34, weight: .heavy))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Username")
                    .font(.system(size: 24, weight: .semibold))
                
                
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(height: 14)
                    Text("Online")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.lightGray))
                }
            }
            Spacer()
            
            Button {
                shouldShowLogoutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogoutOptions) {
            .init(
                title: Text("Seetings"),
                message: Text("What do you want to do ?"),
                buttons: [
                    .destructive(Text("Sign Out"), action: {
                        print("handle sign out") }),
                    .cancel()
                ]
            )
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                customNavBar
                messagesView
            }
            .overlay(
                newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(1..<10, id: \.self) { num in
                VStack {
                    HStack(spacing: 16) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 44)
                                .stroke(Color(.label), lineWidth: 1))
                        VStack(alignment: .leading) {
                            Text("Username")
                                .font(.system(size: 16, weight: .bold))
                            Text("Message sent to user")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.lightGray))
                        }
                        Spacer()
                        Text("22d")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom, 50)

    }
                
    private var newMessageButton: some View {
        Button {
            
        } label: {
            HStack {
                Spacer()
                Text("+ new Message")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.vertical)
                Spacer()
            }
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(24)
            .padding(.horizontal)
            .shadow(radius: 5)
            
        }
    }
}

#Preview {
    MainMessagesView()
}
