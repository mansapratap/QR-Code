//
//  ContentView.swift
//  QR Code
//
//  Created by Mansa Pratap Singh on 12/06/21.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @State private var text = ""
    @State private var selectedCodeStyle = 1
    @State private var codeImage = UIImage()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Text or NUmber", text: $text).padding(8)
                    .multilineTextAlignment(.center)
                    .background(Color(.quaternarySystemFill))
                    .cornerRadius(8)
                
                Picker(selection: $selectedCodeStyle, label: Text("Picker")) {
                    Text("QR Code").tag(1)
                    Text("Bar Code").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                
                Spacer()
                
                Image(uiImage: codeImage).resizable()
                    .interpolation(.none)
                    .frame(width: 250, height: 250)
                    .border(Color.black, width: 2)
                
                Spacer()

                Button(action: {
                    codeImage = generateCode(from: text)
                }, label: {
                    Text("Generate Code").bold().font(.title2)
                        .frame(width: 250, height: 50)
                        .background(Color(.black))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                })
            }.padding()
            .cornerRadius(8)
            .navigationBarTitle("Code Generator")
        }
    }
    
    func generateCode(from text: String) -> UIImage {
        var image = UIImage()
        var filter = CIFilter()
        if text != "" {
            let data = Data(text.utf8)
            if selectedCodeStyle == 1 {
                filter = CIFilter(name: "CIQRCodeGenerator")!
            } else {
                filter = CIFilter(name: "CICode128BarcodeGenerator")!
            }
            
            filter.setValue(data, forKey: "inputMessage")
            if let ciImage = filter.outputImage {
                let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent)
                image = UIImage(cgImage: cgImage!)
            } else {
                image = UIImage(systemName: "xmark.circle")!
            }
        }
        return image
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
