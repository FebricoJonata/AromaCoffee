//
//  AuthViewModel.swift
//  CoffeShop
//
//  Created by Febrico Jonata on 03/12/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


@MainActor
class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init(){
        self.userSession = Auth.auth().currentUser
        
        Task{
            await fetchAccount()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws{
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchAccount()
        }catch{
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullName: String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchAccount()
        }catch{
            print("DEBUG : Failed to create User with error \(error.localizedDescription)")
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        }catch{
            print("DEBUG: Failed to Sign Out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount(){
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: User not authenticated.")
            return
        }
        
        // Delete the user account
        Auth.auth().currentUser?.delete(completion: { [weak self] error in
            if let error = error {
                print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
                return
            }
            
            // Delete the user data from Firestore
            Firestore.firestore().collection("users").document(uid).delete { error in
                if let error = error {
                    print("DEBUG: Failed to delete data with error \(error.localizedDescription)")
                    return
                }
                
                // Set userSession and currentUser to nil after deletion
                self?.userSession = nil
                self?.currentUser = nil
                
                print("DEBUG: Account and data deleted successfully")
            }
        })
        
    }
    
    func fetchAccount() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        
        print("DEBUG : Current User is \(self.currentUser)")
    }
}
