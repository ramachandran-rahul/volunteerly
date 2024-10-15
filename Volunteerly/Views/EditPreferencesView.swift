//
//  EditPreferencesView.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 16/10/24.
//

import SwiftUI

struct EditPreferencesView: View {
    @ObservedObject var userViewModel: UserViewModel
    @EnvironmentObject var eventsViewModel: EventsViewModel
    @State private var selectedPreferences: [String] = []
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    // Heading and guiding text
                    Text("Update Preferences")
                        .font(.title)
                        .bold()
                        .padding(.top)
                    
                    Text("Update your preferences here so we can find you opportunities that you will love.")
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    ScrollView {
                        // Preferences section using VStack and HStack
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(Constants.categories, id: \.self) { preference in
                                HStack {
                                    Image(systemName: selectedPreferences.contains(preference) ? "checkmark.square.fill" : "square")
                                        .foregroundColor(selectedPreferences.contains(preference) ? .green : .gray)
                                        .font(.title)
                                        .onTapGesture {
                                            toggleSelection(preference: preference)
                                        }
                                    Text(preference)
                                        .font(.title3)
                                }
                                .padding(.bottom)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 10)
                
                Spacer()
                
                // Save button
                Button(action: {
                    savePreferences()
                }) {
                    Text("Save Preferences")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
            .onAppear {
                selectedPreferences = userViewModel.preferences
            }
        }
    }
    
    // Function to toggle the preference selection
    private func toggleSelection(preference: String) {
        if selectedPreferences.contains(preference) {
            selectedPreferences.removeAll { $0 == preference }
        } else {
            selectedPreferences.append(preference)
        }
    }

    // Function to save the preferences
    private func savePreferences() {
        // Update the user preferences in Firebase
        userViewModel.updatePreferences(selectedPreferences) {
            userViewModel.fetchUserData {
                // Trigger a refetch in EventsViewModel after preferences are updated
                eventsViewModel.fetchEvents {
                    // Dismiss the sheet after preferences are saved and data is fetched
                    isPresented = false
                }
            }
        }
    }
}

struct EditPreferencesView_Previews: PreviewProvider {
    @State static var isPresented = true
    
    static var previews: some View {
        EditPreferencesView(userViewModel: UserViewModel(), isPresented: $isPresented)
    }
}
