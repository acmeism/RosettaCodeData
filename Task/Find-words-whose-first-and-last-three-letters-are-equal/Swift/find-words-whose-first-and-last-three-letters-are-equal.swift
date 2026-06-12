import Foundation

do {
    try String(contentsOfFile: "unixdict.txt", encoding: String.Encoding.ascii)
        .components(separatedBy: "\n")
        .filter{$0.count > 5 && $0.prefix(3) == $0.suffix(3)}
        .enumerated()
        .forEach{print("\($0.0 + 1). \($0.1)")}
} catch {
    print(error.localizedDescription)
}
