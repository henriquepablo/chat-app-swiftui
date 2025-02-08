//
//  ContentView.swift
//  SwiftUIChatApp
//
//  Created by pablo henrique on 01/02/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init( )
    }
}

struct LoginView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    
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
                            shouldShowImagePicker
                                .toggle()
                        } label: {
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 128, height: 128)
                                        .scaledToFill()
                                        .cornerRadius(64)
                                    
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(Color.black)
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64).stroke(Color.black, lineWidth: 3))
                        }
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
 
                        SecureField("Password", text: $password)

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
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
    
    private func handleAction() {
        if (isLoginMode) {
            print("Should log into Firebas with existing credentials")
            loginUser()
        } else {
            createNewAccount()
            print("Register a new account inside of Firebase Auth and then store image in Storage somehow...")
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) {
            result, err in
            
            if let err = err {
                print("Failed to login  a user", err)
                return
            }
            
            print("SuccessFullly logged user: \(result?.user.uid ?? "")")
        }
    }
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to create a user", err)
                return
            }
            
            print("SuccessFullly created a new user: \(result?.user.uid ?? "")")
            
            self.storeUserInformation()
            //persistImageToStorage()
        }
    }
    
    private func storeUserInformation() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["email": self.email, "uid": uid]
        FirebaseManager.shared.firestore.collection("users").document(uid).setData(userData) { err in
                if let err = err {
                print("Failed to add user data to firestore: ", err)
                return
            }
            print("Success ")
        }
    }
    
    /*private func persistImageToStorage() {
        let filename = UUID().uuidString
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageDate = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageDate, metadata: nil) { metadata, err in
            if let err = err {
                print("Failed to upload image: ", err)
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    print("Failed to retrive a download url: ", err)
                    return
                }
                
                print("Successfully uploaded an image: \(url?.absoluteString ?? "")")
            }
        }
    }*/
}

#Preview {
    LoginView()
}
