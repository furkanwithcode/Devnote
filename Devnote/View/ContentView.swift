//
//  ContentView.swift
//  Devnote
//
//  Created by Furkan Cingöz on 26.11.2023.
//
// % 90
import SwiftUI
import CoreData

struct ContentView: View {

  //MARK: - PROPERTY
  @State var task = ""
  @State private var showNewTaskItem: Bool = false
  @AppStorage("isDarkMode") private var isDarkMode: Bool = false

  //MARK FETCHING DATA
  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Item>

  //MARK: - FUNCTION


  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map { items[$0] }.forEach(viewContext.delete)


      do {
        try viewContext.save()
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
  //MARK: - BODY

  @available(iOS 16.0, *)
  var body: some View {
    NavigationView {
      ZStack {
        //MARK: - MAIN VIEW
        VStack {
          //MARK: - HEADER
          HStack(spacing: 10) {
            //TITLE

            Text("Devnote")
              .font(.system(.largeTitle,design: .rounded))
              .fontWeight(.heavy)
              .padding(.leading,4)
            Spacer()

            //EDIT BUTTON
            EditButton()
              .font(.system(size: 16,weight: .semibold,design: .rounded))
              .padding(.horizontal,10)
              .frame(minWidth: 70,minHeight: 24)
              .background(
                Capsule().stroke(Color.white,lineWidth: 2)
              )
            //APPEARNCE BUTTON
            Button(action: {
              isDarkMode.toggle()
            }, label: {
              Image(systemName: isDarkMode ? "moon.circle.fill" :"moon.circle")
                .resizable()
                .frame(width: 24,height: 24)
                .font(.system(.title,design: .rounded))
            })

          }// header hstack
          .padding()
          .foregroundColor(.white)
          Spacer(minLength: 80)
          //MARK: - NEW TASK BUTTON
          Button(action:  {
            showNewTaskItem = true
          }, label: {
            Image(systemName: "plus.circle")
              .font(.system(size: 30,weight: .semibold, design: .rounded))
            Text("New Task")
              .font(.system(size: 24,weight: .bold,design: .rounded))
          })
          .foregroundColor(.white)
          .padding(.horizontal,20)
          .padding(.vertical,15)
          .background(
            LinearGradient(gradient: Gradient(colors: [Color.pink,Color.blue]), startPoint: .leading, endPoint: .trailing).clipShape(Capsule())
          )
          .shadow(color: Color(red:0, green: 0, blue:0, opacity: 0.25),radius: 8, x:0.0, y:4.0)

          //MARK: - TASKS


          List {
            ForEach(items) { item in
             ListRowItemView(item: item)
              }.onDelete(perform: deleteItems)
            }
          .listStyle(InsetGroupedListStyle())
          .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3),radius: 12)
          .padding(.vertical,0)
          .frame(maxWidth: 640)
        }
        //MARK: - NEW TASK ITEM
        if showNewTaskItem{
          BlankView()
            .onTapGesture {
              withAnimation() {
                showNewTaskItem = false
              }
            }
          NewTaskItemView(isShowing: $showNewTaskItem)
        }

      }     //: ZSTACK
      .scrollContentBackground(.hidden)
      .navigationTitle("Daily Task").navigationBarTitleDisplayMode(.large)
      .navigationBarHidden(true)
      .background(
        BackgroundImageView()
      )
      .background(
        backgroundGradient.ignoresSafeArea(.all)
      )
    }//:Navigation
    .navigationViewStyle(StackNavigationViewStyle())
  }
}


//MARK: - PREVIEW
#Preview {
  ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
