import rand
import os

const answers = ["It is certain", "It is decidedly so", "Without a doubt",
                 "Yes, definitely", "You may rely on it", "As I see it, yes",
                 "Most likely", "Outlook good", "Signs point to yes", "Yes",
                 "Reply hazy, try again", "Ask again later",
                 "Better not tell you now", "Cannot predict now",
                 "Concentrate and ask again", "Don't bet on it",
                 "My reply is no", "My sources say no", "Outlook not so good",
                 "Very doubtful"]

fn main() {
	mut str :=""
	for	{
        str = os.input_opt("Please enter your question or a blank line to quit? \n") or {panic(err)}.str()	
        if str =="" {
                println("No answer, so exiting!")
                break
        }
        else {
                rnum := rand.int_in_range(0, answers.len) or {exit(1)}
                println(answers[rnum])
        }
    }
}
