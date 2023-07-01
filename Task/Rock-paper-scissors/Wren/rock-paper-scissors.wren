import "random" for Random
import "/str" for Str
import "/ioutil" for Input

var choices = "rpsq"
var rand = Random.new()

var pWins  = 0          // player wins
var cWins  = 0          // computer wins
var draws  = 0          // neither wins
var games  = 0          // games played
var pFreqs = [0, 0, 0]  // player frequencies for each choice (rps)

var printScore = Fn.new {
    System.print("Wins: You %(pWins), Computer %(cWins), Neither %(draws)\n")
}

var getComputerChoice = Fn.new {
    // make a completely random choice until 3 games have been played
    if (games < 3) return choices[rand.int(3)]
    var num = rand.int(games)
    return (num < pFreqs[0]) ? "p" :
           (num < pFreqs[0] + pFreqs[1]) ? "s" : "r"
}

System.print("Enter: (r)ock, (p)aper, (s)cissors or (q)uit\n")
while (true) {
    printScore.call()
    var pChoice = Str.lower(Input.option("Your choice r/p/s/q : ", "rpsqRPSQ"))
    if (pChoice == "q") {
        System.print("OK, quitting")
        return
    }
    var cChoice = getComputerChoice.call()
    System.print("Computer's choice   : %(cChoice)")
    if (pChoice == "r" && cChoice == "s") {
        System.print("Rock breaks scissors - You win!")
        pWins = pWins + 1
    } else if (pChoice == "p" && cChoice == "r") {
        System.print("Paper covers rock - You win!")
        pWins = pWins + 1
    } else if (pChoice == "s" && cChoice == "p") {
        System.print("Scissors cut paper - You win!")
        pWins = pWins + 1
    } else if (pChoice == "s" && cChoice == "r") {
        System.print("Rock breaks scissors - Computer wins!")
        cWins = cWins + 1
    } else if (pChoice == "r" && cChoice == "p") {
        System.print("Paper covers rock - Computer wins!")
        cWins = cWins + 1
    } else if (pChoice == "p" && cChoice == "s") {
        System.print("Scissors cut paper - Computer wins!")
        cWins = cWins + 1
    } else {
        System.print("It's a draw!")
        draws = draws + 1
    }
    var pf = pFreqs[choices.indexOf(pChoice)]
    pFreqs[choices.indexOf(pChoice)] = pf + 1
    games = games + 1
    System.print()
}
