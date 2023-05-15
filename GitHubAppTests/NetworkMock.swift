import Foundation
@testable import GitHubApp

class NetworkMock: NetworkProtocol {
    
    
    func performGet(url: URL, completion: @escaping (Data?)->Void) {

        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "Mock", ofType: "json") else {
            fatalError("Mock.json not found")
        }

        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert Mock.json to String")
        }

        guard let data = jsonString.data(using: .utf8) else {
            fatalError("Unable to convert Mock.json to Data")
        }

        completion(data)
    }
    
}
