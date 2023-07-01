import Cocoa

var found = false
let fh = NSFileHandle.fileHandleWithStandardInput()
println("Enter an integer between 1 and 100 for me to guess: ")
let data = fh.availableData
var num:Int!
var low = 0.0
var high = 100.0
var lastGuess:Double!


if let numFromData = NSString(data: data, encoding: NSUTF8StringEncoding)?.intValue {
    num = Int(numFromData)
}

func guess() -> Double? {
    if (high - low == 1) {
        println("I can't guess it. I think you cheated.");
        return nil
    }

    return floor((low + high) / 2)
}

while (!found) {
    if let guess = guess() {
        lastGuess = guess

    } else {
        break
    }
    println("My guess is: \(Int(lastGuess))")
    println("How was my guess? Enter \"higher\" if it was higher, \"lower\" if it was lower, and \"correct\" if I got it")
    let data = fh.availableData
    let str = NSString(data: data, encoding: NSUTF8StringEncoding)
    if (str == nil) {
        continue
    }
    if (str! == "correct\n") {
        found = true
        println("I did it!")
    } else if (str! == "higher\n") {
        low = lastGuess
    } else if (str! == "lower\n") {
        high = lastGuess
    }
}
