import Darwin
import Foundation

println("24 Game")
println("Generating 4 digits...")

func randomDigits() -> Int[] {
    var result = Int[]();
    for var i = 0; i < 4; i++ {
        result.append(Int(arc4random_uniform(9)+1))
    }
    return result;
}

// Choose 4 digits
let digits = randomDigits()

print("Make 24 using these digits : ")

for digit in digits {
    print("\(digit) ")
}
println()

// get input from operator
var input = NSString(data:NSFileHandle.fileHandleWithStandardInput().availableData, encoding:NSUTF8StringEncoding)

var enteredDigits = Int[]()

var enteredOperations = Character[]()

let inputString = input as String

// store input in the appropriate table
for character in inputString {
    switch character {
        case "1", "2", "3", "4", "5", "6", "7", "8", "9":
            let digit = String(character)
            enteredDigits.append(digit.toInt()!)
        case "+", "-", "*", "/":
            enteredOperations.append(character)
        case "\n":
            println()
        default:
            println("Invalid expression")
    }
}

// check value of expression provided by the operator
var value = Int()

if enteredDigits.count == 4 && enteredOperations.count == 3 {
    value = enteredDigits[0]
    for (i, operation) in enumerate(enteredOperations) {
        switch operation {
            case "+":
                value = value + enteredDigits[i+1]
            case "-":
                value = value - enteredDigits[i+1]
            case "*":
                value = value * enteredDigits[i+1]
            case "/":
                value = value / enteredDigits[i+1]
            default:
                println("This message should never happen!")
        }
    }
}

if value != 24 {
    println("The value of the provided expression is \(value) instead of 24!")
} else {
    println("Congratulations, you found a solution!")
}
