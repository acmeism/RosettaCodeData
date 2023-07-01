{prompt: "Please enter your guess:", random: (1+rand(9)) }
| ( (while( .guess != .random; .guess = (input|tonumber) ) | .prompt),
  "Well done!"
