def rand:
  input as $r
  | if $r < . then $r else rand end;

def logical_montyHall:
  . as $games
  | {switchWins: 0, stayWins: 0}
  | reduce range (0; $games) as $_ (.;
          (3|rand) as $car                     # put car in a random door
        | (3|rand) as $choice                  # choose a door at random
        | if $choice == $car then .stayWins += 1
	  else .switchWins += 1
	  end )
    | "Simulating \($games) games:",
      "Staying   wins \(.stayWins) times",
      "Switching wins \(.switchWins) times\n" ;

1e3, 1e6 | logical_montyHall
