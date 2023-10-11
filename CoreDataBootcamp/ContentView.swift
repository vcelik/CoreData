//
//  ContentView.swift
//  CoreDataBootcamp
//
//  Created by Volkan Celik on 22/09/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: FruitEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FruitEntity.name, ascending: true)]) var fruits:FetchedResults<FruitEntity>
    
    @State var textFieldText:String=""

    var body: some View {
        NavigationView {
            VStack(spacing:20) {
                
                TextField("Add fruit here...", text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.gray)
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button {
                    addItem()
                } label: {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                List {
                    ForEach(fruits) { fruit in
                        Text(fruit.name ?? "")
                            .onTapGesture {
                                updateItem(fruit: fruit)
                            }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Fruits")
                .toolbar {
    //                ToolbarItem(placement: .navigationBarLeading) {
    //                    EditButton()
    //                }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
            }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newFruit = FruitEntity(context: viewContext)
            newFruit.name=textFieldText
            saveItems()
            textFieldText=""
        }
    }
    
    private func updateItem(fruit:FruitEntity){
        withAnimation {
            let currentName=fruit.name ?? ""
            let newName=currentName + "!"
            fruit.name=newName
            saveItems()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            //offsets.map { items[$0] }.forEach(viewContext.delete)
            guard let index=offsets.first else {return}
            let fruitEntity=fruits[index]
            viewContext.delete(fruitEntity)
            saveItems()
        }
    }
    
    private func saveItems(){
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
