def tasks:

  def taskA:
    maximal_by(.[1]) | .[0];

  def taskB:
    map(select(.[1]|length > 7))
    | group_by(.[1])
    | map( .[0][1] as $m | [$m, map(.[0])] )
    | .[]
    | if .[1]|length==1
      then "\nThe eligible word with \(.[0]) consonants is:"
      else "\nThe eligible words with \(.[0]) consonants are:"
      end,
      .[1] ;

  [inputs
   | select(length>10)
   | consonants as $c
   | select($c | letters_are_distinct)
   | [., ($c|length)] ]
  | ("Eligible words with the maximal number of consonants:",
     taskA,
     taskB) ;

tasks
