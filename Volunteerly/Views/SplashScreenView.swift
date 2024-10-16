//
//  SplashScreenView.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 13/10/24.
//

import SwiftUI
import SVProgressHUD

struct SplashScreenView: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Image("AppLogo1Splash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .padding(.bottom)
            Text("Volunteerly").font(.title).fontWeight(.bold).padding(.bottom, 10)
            Text("Find volunteering opportunities in your area").fontWeight(.semibold).padding(.horizontal, 30).padding(.bottom, 200).multilineTextAlignment(.center)
            Spacer()
        }
        .onAppear {
            // Customise SVProgressHUD appearance
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setBackgroundColor(.clear)
            SVProgressHUD.setForegroundColor(.black)
            SVProgressHUD.setRingThickness(5.0)
            SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: 250))
            SVProgressHUD.show()
        }
        .onDisappear() {
            SVProgressHUD.dismiss()
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView(isLoading: .constant(true))
    }
}
