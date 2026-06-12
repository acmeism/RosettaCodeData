# If $details then provide {details, coins}, otherwise just the number of coins.
def minimum_number($details):
  . as $amount
  | [200, 100, 50, 20, 10, 5, 2, 1] as $denoms
  | {coins: 0, remaining: 988, details: []}
  | label $out
  | foreach $denoms[] as $denom (.;
       ((.remaining / $denom)|floor) as $n
       | if $n > 0
         then .coins += $n
 	 | if $details then .details += [{$denom, $n}] else . end
         | .remaining %= $denom
	 else . end;
         if .remaining == 0 then ., break $out else empty end)
  | if $details then {details, coins} else .coins end ;

# Verbose mode:
def task:
 "\nThe minimum number of coins needed to make a value of \(.) is as follows:",
  (minimum_number(true)
   | .details[],
     "\nA total of \(.coins) coins in all." );


988
| minimum_number(false),  # illustrate minimal output
  task                    # illustrate detailed output
