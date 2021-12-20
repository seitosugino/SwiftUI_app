//
//  ContentView.swift
//  iOSapp
//
//  Created by 杉野　星都 on 2021/12/20.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String?
    var formattedPrice: String?
}

struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        NavigationView{
            List(results, id: \.trackId){item in
                VStack(alignment: .leading){
                    NavigationLink(destination: ShowDiteil()) {
                        Text(item.trackName ?? "").font(.headline)
                        Text(item.formattedPrice ?? "")
                    }
                }
            }.navigationTitle("appStoreアプリ")
                .navigationBarItems(leading: Button(action: {
                    print("左のボタンが押されました。")
                }, label: {
                    Text("検索")
                }), trailing: HStack {
                    Button(action: {
                        print("右のボタン１が押されました。")
                    }, label: {
                        Text("メモ")
                    })
                })
        }.onAppear(perform: loadData)
    }
    
    func loadData(){
        guard let URL = URL(string: "https://itunes.apple.com/search?term=swiftui&country=jp&media=software")else{
            return
        }
        
        let request = URLRequest(url: URL)
        
        URLSession.shared.dataTask(with: request){data, response, error in
            if let data = data{
                let decoder = JSONDecoder()
                guard let decodedResponse = try? decoder.decode(Response.self, from: data)else{
                    print("JSON decode エラー")
                    return
                }
                
                DispatchQueue.main.async {
                    results = decodedResponse.results
                }
            }else{
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
}

struct ShowDiteil: View{
    
    var body: some View{
        Text("1")
    }
}

struct NoteView: View{
    @State var content: String = ""
    @State var list: [String] = []
    
    var body: some View {
        VStack{
            HStack{
                Text("メモの追加").font(.largeTitle).padding(.leading)
                Spacer()
            }
            HStack{
                TextField("メモを入れてください", text: $content).textFieldStyle(RoundedBorderTextFieldStyle()).frame(width:300)
                Button(action: {
                    self.list.append(self.content)
                    self.content = ""
                }){
                    ZStack {
                        RoundedRectangle(cornerRadius: 5).frame(width:50,height: 30)
                        Text("保存").foregroundColor(.white)
                    }
                }
            }
            
            HStack{
                Text("メモの一覧").font(.largeTitle).padding(.leading)
                Spacer()
            }
            
            List(list, id: \.self) {content in
                Text(content)
            }
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}
