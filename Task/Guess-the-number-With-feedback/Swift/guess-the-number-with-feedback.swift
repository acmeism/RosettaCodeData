import Cocoa

var found = false

let randomNum = Int(arc4random_uniform(100) + 1)

println("Guess a number between 1 and 100\n")

while (!found) {
    var fh = NSFileHandle.fileHandleWithStandardInput()

    println("Enter a number: ")
    let data = fh.availableData
    let str = NSString(data: data, encoding: NSUTF8StringEncoding)
    if (str?.integerValue == randomNum) {
        found = true
        println("Well guessed!")
    } else if (str?.integerValue < randomNum) {
        println("Good try but the number is more than that!")
    } else if (str?.integerValue > randomNum) {
        println("Good try but the number is less than that!")
    }
}
