import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: PomodoroTimerViewModel
    @Binding var bgImage: String
    @State var showingCategories = false
    
    var body: some View {
        ZStack {
            Image(bgImage)
                .resizable()
                .ignoresSafeArea()
            VStack {
                //MARK: - Focus Category Button
                Button(action: {
                    showingCategories.toggle()
                }, label: {
                    Text(viewModel.selectedCategory?.displayName ?? "Focus Category")
                        .frame(width: 160, height: 36)
                        .background(.gray.opacity(0.5))
                        .cornerRadius(16)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.white)
                })
                .sheet(isPresented: $showingCategories, content: {
                    CategorySheetView(showingCategories: $showingCategories, viewModel: viewModel)
                        .presentationDetents([.height(300)])
                })
                
                //MARK: - Timer Circle
                
                //MARK: - Pause/Resume & Stop Buttons
                
            }
        }
    }
}

#Preview {
    MainView(viewModel: mockViewModel, bgImage: .constant("bg1"))
}
