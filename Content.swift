import SwiftUI

struct Content: View {
    @ObservedObject var result: Result
    var refresh: () -> Void

    var body: some View {
        Loading(loading: $result.loading, error: $result.error) {
            NavigationView {
                Listing(result: self.result)
                    .navigationBarTitle(Text(.init("List.title")))
                    .navigationBarItems(
                        trailing: Button(action: self.refresh) {
                            Image(systemName: "arrow.2.circlepath")
                        }
                        .frame(width: 90, height: 90, alignment: .trailing)
                    )
                Recipe()
            }.navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }
}

private struct Loading<List>: View where List: View {
    @Binding var loading: Bool
    @Binding var error: Error?
    var list: () -> List
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.list()
                    .disabled(self.loading || self.error != nil)
                    .blur(radius: self.loading || self.error != nil ? 3 : 0)
                VStack {
                    Text(.init("List.loading"))
                    Image(systemName: "arrow.2.circlepath.circle")
                }
                .frame(width: geometry.size.width / 2, height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.loading ? 1 : 0)
                VStack {
                    Text(self.error?.localizedDescription ?? "")
                        .frame(width: geometry.size.width / 2, height: geometry.size.height / 6)
                    Button(action: {
                        self.error = nil
                    }, label: { Text(.init("List.continue")) })
                }
                .frame(width: geometry.size.width / 1.5, height: geometry.size.height / 4)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.error == nil ? 0 : 1)
            }
        }
    }
}

private struct Listing: View {
    @ObservedObject var result: Result

    var body: some View {
        List {
            ForEach(result.recipes, id: \.self) { recipe in
                NavigationLink(destination: Recipe(recipe: recipe)) {
                    Image(uiImage: UIImage(data: self.result.images[recipe.fields.photo.sys.id] ?? Data()) ?? UIImage())
                        .frame(width: 50, height: 50)
                        .padding(.top, 10)
                        .padding(.leading, 10)
                        .padding(.bottom, 10)
                        .clipped()
                        .scaledToFit()
                        .background(Color.secondary)
                    Text(recipe.fields.title)
                }
            }
        }
    }
}

private struct Recipe: View {
    var recipe = Recipes.Item()

    var body: some View {
        Group {
            ScrollView {
                VStack {
                    Text(recipe.fields.title)
                }
            }
        }.navigationBarTitle(Text(.init("Recipe.title")))
    }
}
