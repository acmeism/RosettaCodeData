import "/ioutil" for Input
import "/str" for Str
import "random" for Random

var name1 = Input.text("Player 1 - Enter your name : ").trim()
name1 = (name1 == "") ? "PLAYER1" : Str.upper(name1)
var name2 = Input.text("Player 2 - Enter your name : ").trim()
name2 = (name2 == "") ? "PLAYER2" : Str.upper(name2)
var names = [name1, name2]
var r = Random.new()
var totals = [0, 0]
var player = 0
while (true) {
    System.print("\n%(names[player])")
    System.print("  Your total score is currently %(totals[player])")
    var score = 0
    while (true) {
        var rh = Str.lower(Input.option("  Roll or Hold r/h : ", "rhRH"))
        if (rh == "h") {
            totals[player] = totals[player] + score
            System.print("  Your total score is now %(totals[player])")
            if (totals[player] >= 100) {
                System.print("  So, %(names[player]), YOU'VE WON!")
                return
            }
            player = (player == 0) ? 1 : 0
            break
        }
        var dice = r.int(1, 7)
        System.print("    You have thrown a %(dice)")
        if (dice == 1) {
            System.print("    Sorry, your score for this round is now 0")
            System.print("  Your total score remains at %(totals[player])")
            player = (player == 0) ? 1 : 0
            break
        }
        score = score + dice
        System.print("    Your score for the round is now %(score)")
    }
}
