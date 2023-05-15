import XCTest
@testable import GitHubApp

class ServiceTests: XCTestCase {

    func testFetchList() throws {
        
        let network = NetworkMock()
        let service = Service(network: network)
        
        let expectation = self.expectation(description: "Fetching")
        var names: [String]?

        service.fetchList(of: "") { repos in
            guard let repos = repos else {
                XCTFail()
                return
            }
            names = repos.map { $0.name }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssertEqual(names, ["Repository 1", "Repository 2", "Repository 3"])
    }
}
