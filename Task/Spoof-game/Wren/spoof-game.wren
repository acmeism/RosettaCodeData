import "random" for Random
import "./ioutil" for Input, Output, Stdin
import "./math" for Nums

var TEST = true // set to 'false' to erase each player's coins

var getNumber = Fn.new { |prompt, min, max, showMinMax|
    prompt = prompt + (showMinMax ? " from %(min) to %(max) : " : " :  ")
    var input = Input.integer(prompt, min, max)
    System.print()
    return input
}

var rand = Random.new()
var players = getNumber.call("Number of players", 2, 9, true)
var coins = getNumber.call("Number of coins per player", 3, 6, true)
var remaining = List.filled(players, 0)
for (i in 0...players) remaining[i] = i + 1
var first = 1 + rand.int(players)
var round = 1
System.print("The number of coins in your hand will be randomly determined for")
System.print("each round and displayed to you. However, when you press ENTER")
System.print("it will be erased so that the other players, who should look")
System.print("away until it's their turn, won't see it. When asked to guess")
System.print("the total, the computer won't allow a 'bum guess'.")
while(true) {
    System.print("\nROUND %(round):\n")
    var n = first
    var hands = List.filled(players + 1, 0)
    var guesses = List.filled(players + 1, -1)
    while (true) {
        System.print("  PLAYER %(n):")
        System.print("    Please come to the computer and press ENTER")
        hands[n] = rand.int(coins + 1)
        Output.fwrite("      <There are %(hands[n]) coin(s) in your hand>")
        Stdin.readLine()
        if (!TEST) {
            System.write("\e[1A")  // move cursor up one line
            System.write("\e[2K")  // erase line
            System.print("\r")     // move cursor to beginning of line
        } else System.print()
        while (true) {
            var min = hands[n]
            var max = (remaining.count - 1) * coins + hands[n]
            var guess = getNumber.call("    Guess the total", min, max, false)
            if (!guesses.contains(guess)) {
                guesses[n] = guess
                break
            }
            System.print("    Already guessed by another player, try again")
        }
        var index = remaining.indexOf(n)
        n = (index < remaining.count - 1) ? remaining[index + 1] : remaining[0]
        if (n == first) break
    }
    var total = Nums.sum(hands)
    System.print("  Total coins held = %(total)")
    var eliminated = false
    for (i in remaining) {
        if (guesses[i] == total) {
            System.print("  PLAYER %(i) guessed correctly and is eliminated")
            remaining.remove(i)
            eliminated = true
            break
        }
    }
    if (!eliminated) {
        System.print("  No players guessed correctly in this round")
    } else if (remaining.count == 1) {
        System.print("\nPLAYER %(remaining[0]) buys the drinks!")
        return
    }
    var index2 = remaining.indexOf(n)
    first = (index2 < remaining.count - 1) ? remaining[index2 + 1] : remaining[0]
    round = round + 1
}
