def colors: ["grey", "yellow", "green"];

def wordle($answer; $guess):
  ($guess|length) as $n
  | if ($answer|length) != $n then "The words must be of the same length." | error
    else { answer: (answer | explode),
           guess:  (guess  | explode),
      result: [range(0;$n)|0] }
    | reduce range(0; $n) as $i (.;
        if .guess[$i] == .answer[$i]
        then .answer[$i] = 0
        | .result[$i] = 2
        else .
   end )
    | reduce range(0; $n) as $i (.;
        .guess[$i] as $g
        | (.answer | index($g) ) as $ix
        | if $ix
          then .answer[$ix] = 0
          | .result[$i] = 1
          else .
     end )
    | .result
    end ;

def pairs:
    ["ALLOW", "LOLLY"],
    ["BULLY", "LOLLY"],
    ["ROBIN", "ALERT"],
    ["ROBIN", "SONIC"],
    ["ROBIN", "ROBIN"]
;

pairs
| wordle(.[0]; .[1]) as $res
| ($res | map(colors[.])) as $res2
| "\(.[0]) v \(.[1]) => \($res) => \($res2)"
