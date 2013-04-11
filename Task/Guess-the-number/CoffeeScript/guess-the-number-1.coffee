num = Math.ceil(Math.random() * 10)
guess = prompt "Guess the number. (1-10)"
while parseInt(guess) isnt num
  guess = prompt "YOU LOSE! Guess again. (1-10)"
alert "Well guessed!"
