def areSame($s; $t):
  ($s|length) == ($t|length) and ($s|sort) == ($t|sort);

def task:

  # compare EKG5 and EKG7 for convergence, assuming . has been constructed appropriately:
  def compare:
    first( range(2; .limit) as $i
           | select(.ekg[1][$i] == .ekg[2][$i] and areSame(.ekg[1][0:$i]; .ekg[2][0:$i]))
           | "\nEKG(5) and EKG(7) converge at term \($i+1)." )
    // "\nEKG5(5) and EKG(7) do not converge within \(.limit) terms." ;

  { limit: 100,
    starts: [2, 5, 7, 9, 10],
    ekg: [],
    width: 0  # keep track of the number of characters required to print the results neatly
    }
  | reduce range(0;4) as $i (.; .ekg[$i] = [range(0; .limit) | 0] )
  | reduce range(0; .starts|length ) as $s (.;
      .starts[$s] as $start
      | .ekg[$s][0] = 1
      | .ekg[$s][1] = $start
      | reduce range( 2; .limit) as $n (.;
          .i = 2
	  | .stop = false
          | until( .stop;
              # a potential sequence member cannot already have been used
              # and must have a factor in common with previous member
	      .ekg[$s] as $ekg
              | if (.i | IN( $ekg[0:$n][]) | not) and gcd($ekg[$n-1]; .i) > 1
                then .ekg[$s][$n] = .i
		| .width = ([.width, (.i|tostring|length)] | max)
		| .stop = true
                else .
	        end
              | .i += 1) ) )

  # Read out the results of interest:
  | (range(0; .starts|length ) as $s
     | .width as $width
     | "EKG(\(.starts[$s]|lpad(2))): \(.ekg[$s][0:30]|map(lpad($width))|join(" "))" ),
     compare
    ;

task
