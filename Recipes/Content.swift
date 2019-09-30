import SwiftUI

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

struct Content: View {
    @State private var dates = [Date]()
    @State private var loading = false

    var body: some View {
        Loading(loading: $loading) {
            NavigationView {
                MasterView(dates: self.$dates)
                    .navigationBarTitle(Text(.init("List.title")))
                    .navigationBarItems(
                        leading: EditButton(),
                        trailing: Button(
                            action: {
                                withAnimation { self.loading = true }
                            }
                        ) {
                            Image(systemName: "arrow.2.circlepath")
                        }
                    )
                DetailView()
            }.navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }
}

private struct Loading<List>: View where List: View {
    @Binding var loading: Bool
    var list: () -> List
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.list()
                    .disabled(self.loading)
                    .blur(radius: self.loading ? 3 : 0)
                VStack {
                    Text(.init("List.loading"))
                    Image(systemName: "arrow.2.circlepath.circle")
                }
                .frame(width: geometry.size.width / 2, height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.loading ? 1 : 0)
            }
        }
    }

}

struct MasterView: View {
    @Binding var dates: [Date]

    var body: some View {
        List {
            ForEach(dates, id: \.self) { date in
                NavigationLink(
                    destination: DetailView(selectedDate: date)
                ) {
                    Text("\(date, formatter: dateFormatter)")
                }
            }.onDelete { indices in
                indices.forEach { self.dates.remove(at: $0) }
            }
        }
    }
}

struct DetailView: View {
    var selectedDate: Date?

    var body: some View {
        Group {
            if selectedDate != nil {
                Text("\(selectedDate!, formatter: dateFormatter)")
            } else {
                Text("Detail view content goes here")
            }
        }.navigationBarTitle(Text("Detail"))
    }
}
