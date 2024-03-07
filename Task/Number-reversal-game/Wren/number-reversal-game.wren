import "./sort" for Sort
import "random" for Random
import "io" for Stdin, Stdout

var r= Random.new()
var count = 0
var numbers = [0] * 9
numbers[0] = r.int(2, 10) // this will ensure list isn't ascending
for (i in 1..8) {
    var rn
    while(true) {
        rn = r.int(1, 10)
        if (!numbers.contains(rn)) break
    }
    numbers[i] = rn
}
System.print("Here's your first list : %(numbers)")
while (true) {
    var rev
    while (true) {
        System.write("How many numbers from the left are to be reversed : ")
        Stdout.flush()
        rev = Num.fromString(Stdin.readLine())
        if (rev.type == Num && rev.isInteger && rev >= 2 && rev <= 9) break
    }
    count = count + 1
    var i = 0
    var j = rev - 1
    while (i < j) {
        var temp = numbers[i]
        numbers[i] = numbers[j]
        numbers[j] = temp
        i = i + 1
        j = j - 1
    }
    if (Sort.isSorted(numbers)) {
        System.print("Here's your final list : %(numbers)")
        break
    }
    System.print("Here's your list now   : %(numbers)")
}
System.print("So you've completed the game with a score of %(count)")
