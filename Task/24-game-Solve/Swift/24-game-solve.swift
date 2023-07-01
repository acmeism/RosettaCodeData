import Darwin
import Foundation

var solution = ""

println("24 Game")
println("Generating 4 digits...")

func randomDigits() -> [Int] {
  var result = [Int]()
  for i in 0 ..< 4 {
    result.append(Int(arc4random_uniform(9)+1))
  }
  return result
}

// Choose 4 digits
let digits = randomDigits()

print("Make 24 using these digits : ")

for digit in digits {
  print("\(digit) ")
}
println()

// get input from operator
var input = NSString(data:NSFileHandle.fileHandleWithStandardInput().availableData, encoding:NSUTF8StringEncoding)!

var enteredDigits = [Double]()

var enteredOperations = [Character]()

let inputString = input as String

// store input in the appropriate table
for character in inputString {
  switch character {
  case "1", "2", "3", "4", "5", "6", "7", "8", "9":
    let digit = String(character)
    enteredDigits.append(Double(digit.toInt()!))
  case "+", "-", "*", "/":
    enteredOperations.append(character)
  case "\n":
    println()
  default:
    println("Invalid expression")
  }
}

// check value of expression provided by the operator
var value = 0.0

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

func evaluate(dPerm: [Double], oPerm: [String]) -> Bool {
  var value = 0.0

  if dPerm.count == 4 && oPerm.count == 3 {
    value = dPerm[0]
    for (i, operation) in enumerate(oPerm) {
      switch operation {
      case "+":
        value = value + dPerm[i+1]
      case "-":
        value = value - dPerm[i+1]
      case "*":
        value = value * dPerm[i+1]
      case "/":
        value = value / dPerm[i+1]
      default:
        println("This message should never happen!")
      }
    }
  }
  return (abs(24 - value) < 0.001)
}

func isSolvable(inout digits: [Double]) -> Bool {

  var result = false
  var dPerms = [[Double]]()
  permute(&digits, &dPerms, 0)

  let total = 4 * 4 * 4
  var oPerms = [[String]]()
  permuteOperators(&oPerms, 4, total)


  for dig in dPerms {
    for opr in oPerms {
      var expression = ""

      if evaluate(dig, opr) {
        for digit in dig {
          expression += "\(digit)"
        }

        for oper in opr {
          expression += oper
        }

        solution = beautify(expression)
        result = true
      }
    }
  }
  return result
}

func permute(inout lst: [Double], inout res: [[Double]], k: Int) -> Void {
  for i in k ..< lst.count {
    swap(&lst[i], &lst[k])
    permute(&lst, &res, k + 1)
    swap(&lst[k], &lst[i])
  }
  if k == lst.count {
    res.append(lst)
  }
}

// n=4, total=64, npow=16
func permuteOperators(inout res: [[String]], n: Int, total: Int) -> Void {
  let posOperations = ["+", "-", "*", "/"]
  let npow = n * n
  for i in 0 ..< total {
    res.append([posOperations[(i / npow)], posOperations[((i % npow) / n)], posOperations[(i % n)]])
  }
}

func beautify(infix: String) -> String {
  let newString = infix as NSString

  var solution = ""

  solution += newString.substringWithRange(NSMakeRange(0, 1))
  solution += newString.substringWithRange(NSMakeRange(12, 1))
  solution += newString.substringWithRange(NSMakeRange(3, 1))
  solution += newString.substringWithRange(NSMakeRange(13, 1))
  solution += newString.substringWithRange(NSMakeRange(6, 1))
  solution += newString.substringWithRange(NSMakeRange(14, 1))
  solution += newString.substringWithRange(NSMakeRange(9, 1))

  return solution
}

if value != 24 {
  println("The value of the provided expression is \(value) instead of 24!")
  if isSolvable(&enteredDigits) {
    println("A possible solution could have been " + solution)
  } else {
    println("Anyway, there was no known solution to this one.")
  }
} else {
  println("Congratulations, you found a solution!")
}
