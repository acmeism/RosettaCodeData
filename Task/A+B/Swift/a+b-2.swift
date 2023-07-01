import Foundation

let input = FileHandle.standardInput

let data = input.availableData
let str = String(data: data, encoding: .utf8)!
let nums = str.split(separator: " ")
    .map { String($0.unicodeScalars
        .filter { CharacterSet.decimalDigits.contains($0) }) }

let a = Int(nums[0])!
let b = Int(nums[1])!

print(" \(a + b)")
