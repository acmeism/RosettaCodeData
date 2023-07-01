def rand:
  input as $r
  | if $r < . then $r else rand end;

def montyHall:
  . as $games
  | [range(0;3) | 0 ] as $doors0
  | {switchWins: 0, stayWins: 0}
  | reduce range (0; $games) as $_ (.;
        ($doors0 | .[3|rand] = 1) as $doors    # put car in a random door
        | (3|rand) as $choice                  # choose a door at random
	| .stop = false
        | until (.stop;
            .shown = (3|rand)                  # the shown door
            | if ($doors[.shown] != 1 and .shown != $choice)
	      then .stop=true
	      else .
	      end)
        | .stayWins +=  $doors[$choice]
        | .switchWins +=  $doors[3 - $choice - .shown]
    )
    | "Simulating \($games) games:",
      "Staying   wins \(.stayWins) times",
      "Switching wins \(.switchWins) times\n" ;

1e3, 1e6 | montyHall
