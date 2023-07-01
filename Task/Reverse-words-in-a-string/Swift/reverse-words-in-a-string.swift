import Foundation

// convenience extension for better clarity
extension String {
    var lines: [String] {
        get {
            return self.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        }
    }
    var words: [String] {
        get {
            return self.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }
    }
}

let input = "---------- Ice and Fire ------------\n\nfire, in end will world the say Some\nice. in say Some\ndesire of tasted I've what From\nfire. favor who those with hold I\n\n... elided paragraph last ...\n\nFrost Robert -----------------------\n"

let output = input.lines.map { $0.words.reverse().joinWithSeparator(" ") }.joinWithSeparator("\n")

print(output)
