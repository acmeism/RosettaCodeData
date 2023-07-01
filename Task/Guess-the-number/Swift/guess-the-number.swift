import Cocoa

var found = false
let randomNum = Int(arc4random_uniform(10) + 1)

println("Guess a number between 1 and 10\n")
while (!found) {
    var fh = NSFileHandle.fileHandleWithStandardInput()

    println("Enter a number: ")
    let data = fh.availableData
    var str = NSString(data: data, encoding: NSUTF8StringEncoding)
    if (str?.integerValue == randomNum) {
        found = true
        println("Well guessed!")
    }
}
