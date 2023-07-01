import random, strutils

const Answers = ["It is certain", "It is decidedly so", "Without a doubt",
                 "Yes, definitely", "You may rely on it", "As I see it, yes",
                 "Most likely", "Outlook good", "Signs point to yes", "Yes",
                 "Reply hazy, try again", "Ask again later",
                 "Better not tell you now", "Cannot predict now",
                 "Concentrate and ask again", "Don't bet on it",
                 "My reply is no", "My sources say no", "Outlook not so good",
                 "Very doubtful"]

proc exit() =
  echo "Bye."
  quit QuitSuccess

randomize()

try:
  while true:
    echo "Type your question or an empty line to quit."
    stdout.write "? "
    let question = stdin.readLine()
    if question.strip().len == 0: exit()
    echo Answers[rand(19)], ".\n"
except EOFError:
  exit()
