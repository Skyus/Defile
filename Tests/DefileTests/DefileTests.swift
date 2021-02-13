import XCTest
import class Foundation.Bundle
import Defile

final class DefileTests: XCTestCase {
    func testFull() throws {
      guard #available(macOS 10.13, *) else {
          return
      }

      Stderr.print("Starting…")

      // Basic I/O
      let testString = "Lorem ipsum dolor sit amet."

      try File.open(".test.txt", mode: .write) { f in
        try f.print(testString, terminator: "")
      }

      let readString = File.read(".test.txt")!

      XCTAssertEqual(testString, readString)

      // Path
      let testPath = "/usr/share/example.js"

      XCTAssertEqual(Path.dirname(testPath), "/usr/share")

      XCTAssertEqual(Path.basename(testPath), "example.js")
      XCTAssertEqual(Path.basename(testPath, extension: ".js"), "example")

      XCTAssertEqual(Path.basename(".rc", extension: ".rc"), ".rc")

      XCTAssertEqual(Path.join("/usr", "share", "example.js"), testPath)

      Stderr.print("Temp path: \(Path.tempdir)")

      Stderr.print("Done.")
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testFull", testFull)
    ]
}
