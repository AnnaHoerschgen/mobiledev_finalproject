//
//  APIService.swift
//  mobiledev_finalproject
//
//  Created by HOERSCHGEN, ANNA M. on 5/7/25.
//

import Foundation

class APIService {
    func fetchPokemon(named name: String, retries: Int = 3, delay: TimeInterval = 1.0, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(name.lowercased())"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        // Perform the API request
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // If there is an error, retry if there are remaining attempts
            if let error = error {
                print("Error: \(error.localizedDescription)")
                if retries > 0 {
                    // Retry with exponential backoff (you can adjust this part)
                    DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                        print("Retrying... (\(retries) retries left)")
                        self.fetchPokemon(named: name, retries: retries - 1, delay: delay * 2, completion: completion) // Increase delay with each retry
                    }
                } else {
                    completion(.failure(error))
                }
                return
            }
            
            // Handle successful response
            if let data = data {
                do {
                    let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                    completion(.success(pokemon))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "No data", code: 404, userInfo: nil)))
            }
        }
        
        task.resume()
    }
}
