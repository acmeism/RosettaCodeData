import "./ioutil" for Input

var n = 0
var sum = 0
while (true) {
    var i = Input.integer("Enter integral rainfall (99999 to quit): ")
    if (i == 99999) break
    n = n + 1
    sum = sum + i
    System.print("  The current average rainfall is %(sum/n)")
}
