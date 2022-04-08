import XCTest
@testable import GeneralIdentifiers

final class GeneralIdentifiersTests: XCTestCase {

  /**
   This struct only exists after compilation, it doesn't exist as a physical file in the Source folder
   */
  func test__dynamically_generated_structure_exists() throws {

    let data = GeneralIdentifiers.Profile()

    XCTAssertNotNil(data)
  }
}
