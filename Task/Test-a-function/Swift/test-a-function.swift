import Cocoa
import XCTest

class PalindromTests: XCTestCase {

    override func setUp() {
        super.setUp()

    }

    override func tearDown() {
        super.tearDown()
    }

    func testPalindrome() {
        // This is an example of a functional test case.
        XCTAssert(isPalindrome("abcba"), "Pass")
        XCTAssert(isPalindrome("aa"), "Pass")
        XCTAssert(isPalindrome("a"), "Pass")
        XCTAssert(isPalindrome(""), "Pass")
        XCTAssert(isPalindrome("ab"), "Pass") // Fail
        XCTAssert(isPalindrome("aa"), "Pass")
        XCTAssert(isPalindrome("abcdba"), "Pass") // Fail
    }

    func testPalindromePerformance() {
        // This is an example of a performance test case.
        self.measureBlock() {
            var _is = isPalindrome("abcba")
        }
    }
}
