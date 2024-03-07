import "random" for Random
import "io" for Stdin, Stdout
import "timer" for Timer
import "./str" for Str

var rand = Random.new()

var optimum = {
    "HHH": "THH", "HHT": "THH", "HTH": "HHT", "HTT": "HHT",
    "THH": "TTH", "THT": "TTH", "TTH": "HTT", "TTT": "HTT"
}

var getUserSequence = Fn.new {
    System.print("A sequence of three H or T should be entered")
    var userSeq
    while (true) {
        System.write("Enter your sequence: ")
        Stdout.flush()
        userSeq = Str.upper(Stdin.readLine())
        if (userSeq.count == 3 && userSeq.all { |c| c == "H" || c == "T" }) break
    }
    return userSeq
}

var getComputerSequence = Fn.new { |userSeq|
    var compSeq
    if (userSeq == "") {
        var chars = List.filled(3, null)
        for (i in 0..2) chars[i] = (rand.int(2) == 0) ? "T" : "H"
        compSeq = chars.join()
    } else {
        compSeq = optimum[userSeq]
    }
    System.print("Computer's sequence: %(compSeq)")
    return compSeq
}

var userSeq
var compSeq
var r = rand.int(2)
if (r == 0) {
    System.print("You go first")
    userSeq = getUserSequence.call()
    System.print()
    compSeq = getComputerSequence.call(userSeq)
} else {
    System.print("Computer goes first")
    compSeq = getComputerSequence.call("")
    System.print()
    userSeq = getUserSequence.call()
}
System.print()
var coins = ""
while (true) {
    var coin = (rand.int(2) == 0) ? "H" : "T"
    coins = coins + coin
    System.print("Coins flipped: %(coins)")
    var len = coins.count
    if (len >= 3) {
        var seq = coins[len-3...len]
        if (seq == userSeq) {
            System.print("\nYou win!")
            return
        } else if (seq == compSeq) {
            System.print("\nCompter wins!")
            return
        }
    }
    Timer.sleep(2000) // wait two seconds for next flip
}
