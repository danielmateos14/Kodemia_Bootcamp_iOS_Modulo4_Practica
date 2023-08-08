//
//  PokemonController.swift
//  UserProfile
//
//  Created by danielmateos14 on 05/08/23.
//

import Foundation

//protocol PokemonProtocol{
//    func actualizarUI(recibeObjetoParseado: PokemonModel)
//}

class PokemonController{
    static var shared = PokemonController()
//    var delegate: PokemonProtocol?
    func requestPokemon<T>(recibeGenerico: T, actualizarUI: @escaping (PokemonModel) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(recibeGenerico)") else {
            fatalError("Url Invalida")
            }
        let urlSessions = URLSession.shared
        
        urlSessions.dataTask(with: url) { data, response, error in
            if let _ = error {}
            guard let data = data else {
                fatalError("Data invalida")
            }
            
            guard let response = response as? HTTPURLResponse else {
                fatalError("Respuesta invalida")
            }
            
            guard response.statusCode == 200 else {
                fatalError("Respuesta fallida")
            }
            
            let jsonDecode = JSONDecoder()
            guard let pokemones = try? jsonDecode.decode(PokemonModel.self, from: data) else {
                fatalError("Error al parsea el modelo")
            }
            
            actualizarUI(pokemones)
            print("Pokemon Name -> \(pokemones.name)")
            print("Pokemon Sprite -> \(pokemones.sprites?.frontDefault)")
            print("Pokemon Form URL -> \(pokemones.forms?[0].url)")
            
        }.resume()
    }
}
