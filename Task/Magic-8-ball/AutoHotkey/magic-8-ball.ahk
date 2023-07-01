answers := [
(join
"It is certain", "It is decidedly so", "Without a doubt","Yes, definitely",
"You may rely on it", "As I see it, yes","Most likely", "Outlook good",
"Signs point to yes", "Yes","Reply hazy, try again", "Ask again later",
"Better not tell you now", "Cannot predict now","Concentrate and ask again",
"Don't bet on it","My reply is no", "My sources say no", "Outlook not so good",
"Very doubtful"
)]
Ask:
InputBox, Question, Magic 8-Ball, Please ask your question or a blank line to quit.,,, 130
Random, rnd, 1, 20
if !question
	ExitApp
MsgBox % answers[rnd]
gosub, Ask
return
