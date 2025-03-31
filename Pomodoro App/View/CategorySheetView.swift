//
//  CategorySheetView.swift
//  Pomodoro App
//
//  Created by Адлет Жумагалиев on 29.03.2025.
//

import SwiftUI

struct CategorySheetView: View {
    @Binding var showingCategories: Bool
    @ObservedObject var viewModel: PomodoroTimerViewModel
    private let column = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible(), spacing: 7)
    ]
    
    var body: some View {
        VStack {
            ZStack {
                Text("Focus Category")
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showingCategories.toggle()
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.black)
                    })
                }
                .padding(.trailing, 16)
            }
            .padding(.top, 20)
            LazyVGrid(columns: column, spacing: 20) {
                ForEach(PomodoroTimerViewModel.Category.allCases, id: \.self) { category in
                    Button(action: {
                        viewModel.selectedCategory = category
                        showingCategories.toggle()
                    }, label: {
                        Text("\(category.displayName)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.black)
                            .frame(width: 172, height: 60)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(16)
                    })
                }
            }
            .padding(.top, 20)
            
            Spacer()
        }
    }
}


let dummySession = PomodoroSession(
                focusTime: 1500,
                breakTime: 300,
                state: .paused,
                sessionType: .focus
                )

let mockViewModel = PomodoroTimerViewModel(pomodoro: dummySession)

#Preview {
    CategorySheetView(showingCategories: .constant(true), viewModel: mockViewModel)
}
