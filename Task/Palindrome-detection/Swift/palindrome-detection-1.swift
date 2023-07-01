import Foundation

// Allow for easy character checking
extension String {
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
}

func isPalindrome(str:String) -> Bool {
    if (count(str) == 0 || count(str) == 1) {
        return true
    }
    let removeRange = Range<String.Index>(start: advance(str.startIndex, 1), end: advance(str.endIndex, -1))
    if (str[0] == str[count(str) - 1]) {
        return isPalindrome(str.substringWithRange(removeRange))
    }
    return false
}
