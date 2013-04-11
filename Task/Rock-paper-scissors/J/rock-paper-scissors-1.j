require'misc strings'
game=:3 :0
  outcomes=. rps=. 0 0 0
  choice=. 1+?3
  while.#response=. prompt'  Choose Rock, Paper or Scissors: ' do.
    playerchoice=. 1+'rps' i. tolower {.deb response
    if.4 = playerchoice do.
      smoutput 'Unknown response.'
      smoutput 'Enter an empty line to quit'
      continue.
    end.
    smoutput '    I choose ',choice {::;:'. Rock Paper Scissors'
    smoutput (wintype=. 3 | choice-playerchoice) {:: 'Draw';'I win';'You win'
    outcomes=. outcomes+0 1 2 = wintype
    rps=. rps+1 2 3=playerchoice
    choice=. 1+3|(?0) I.~ (}:%{:)+/\ 0, rps
  end.
  ('Draws:','My wins:',:'Your wins: '),.":,.outcomes
)
