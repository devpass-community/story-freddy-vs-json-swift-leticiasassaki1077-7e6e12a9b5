import Foundation

struct Repository: Codable {
  // Implemente a estrutura do modelo de dados 
}

enum ServiceError: Error {
    case invalidUrl
    case invalidUser
    case noJsonData
    case decodingError
}

protocol NetworkProtocol {
    func performGet(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

class Network: NetworkProtocol {
    func performGet(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(ServiceError.invalidUrl))
                return
            }
            
            guard let data = data else {
                completion(.failure(ServiceError.noJsonData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}

class Service {
    
    private let network: NetworkProtocol
    
    init(network: NetworkProtocol = Network()) {
        self.network = network
    }

    func fetchList<T: Codable>(of user: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: "https://api.github.com/users/\(user)/repos") else {
            completion(.failure(ServiceError.invalidUser))
            return
        }

        network.performGet(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: AnyObject]] else {
                        completion(.failure(ServiceError.noJsonData))
                        return
                    }
                    let jsonDecoder = JSONDecoder()
                    let decode = try jsonDecoder.decode(T.self, from: data)
                    completion(.success(decode))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
