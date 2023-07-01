import "random" for Random
import "io" for Stdin, Stdout

var answers = [
    "It is certain", "It is decidedly so", "Without a doubt",
    "Yes, definitely", "You may rely on it", "As I see it, yes",
    "Most likely", "Outlook good", "Signs point to yes", "Yes",
    "Reply hazy, try again", "Ask again later",
    "Better not tell you now", "Cannot predict now",
    "Concentrate and ask again", "Don't bet on it",
    "My reply is no", "My sources say no", "Outlook not so good",
    "Very doubtful"
]
var rand = Random.new()
System.print("Please enter your question or a blank line to quit.")
while (true) {
    System.write("\n? : ")
    Stdout.flush()
    var question = Stdin.readLine()
    if (question.trim() == "") return
    var answer = answers[rand.int(20)]
    System.print("\n%(answer)")
}
