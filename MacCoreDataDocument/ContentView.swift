//
//  ContentView.swift
//  MacCoreDataDocument
//
//  Created by Eleanor Spenceley on 16/08/2020.
//  Copyright © 2020 Eleanor Spenceley. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  
    @Environment(\.managedObjectContext) var moc
    
	@ObservedObject var document: DocumentObject
    
    var body: some View {
        
        VStack {
            Text("Test Results here...")
            
            self.buildDocument()
            
            Button(action: {
                Document.primeEmptyDocument(moc: self.moc, document: self.document)
            }, label: {
                Text("Add")
            }
            )
                
        }.frame(minWidth: 200,  minHeight: 300)
    }
    
    
    func buildDocument() -> some View {
        
       let array = document.tests_rel?.array as? [TestObject]
    
        return
            VStack {
                    ForEach(array ?? [] ,id: \.self) { testObj in
                        Text(testObj.testString ?? "empty result").frame(maxWidth: .infinity, maxHeight: .infinity)
                }
        }
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//  //      ContentView()
//    }
//}
