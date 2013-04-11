require'misc'

status=:3 :0
  'pid cur tot'=. y
   player=. 'player ',":pid
   potential=. ' potential: ',":cur
   total=. ' total: ',":tot
  smoutput player,potential,total
)

getmove=:3 :0
  whilst.1~:+/choice do.
    choice=.'HRQ' e. prompt '  Roll the dice or Hold or Quit? [R or H or Q]: '
  end.
  choice#'HRQ'
)

NB. simulate an y player game of pig
pigsim=:3 :0
  smoutput (":y),' player game of pig'
  scores=.y#0
  while.100>>./scores do.
    for_player.=i.y do.
      pid=.1+I.player
      smoutput 'begining of turn for player ',":pid
      current=. 0
      whilst. (1 ~: roll) *. 'R' = move do.
        status pid, current, player+/ .*scores
        move=. getmove''
        roll=. 1+?6
        if.'R'=move do.
          smoutput 'rolled a ',":roll
          current=. (1~:roll)*current+roll
        end.
      end.
      scores=. scores+(current*player)+100*('Q'e.move)*-.player
      smoutput 'player scores now: ',":scores
    end.
  end.
  smoutput 'player ',(":1+I.scores>:100),' wins'
)
