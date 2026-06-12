import Foundation

let minLength = 12
let substring = "the"

do {
    try String(contentsOfFile: "unixdict.txt", encoding: String.Encoding.ascii)
        .components(separatedBy: "\n")
        .filter{$0.count >= minLength && $0.contains(substring)}
        .enumerated()
        .forEach{print(String(format: "%2d. %@", $0.0 + 1, $0.1))}
} catch {
    print(error.localizedDescription)
}
