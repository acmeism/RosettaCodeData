USING: arrays formatting grouping kernel math math.functions
math.parser multiline peg peg.ebnf sequences sequences.deep ;

! Make sure a number is monotonically decreasing.
! So "one hundred and three" is valid but
! "three and one hundred" is not.

: check-natural ( seq -- )
    [ > ] monotonic? [ "Invalid number." throw ] unless ;


! Parse number names with Factor's EBNF-like DSL.

EBNF: text>number [=[
  one       = "one"~       => [[ 1 ]]
  two       = "two"~       => [[ 2 ]]
  three     = "three"~     => [[ 3 ]]
  four      = "four"~      => [[ 4 ]]
  five      = "five"~      => [[ 5 ]]
  six       = "six"~       => [[ 6 ]]
  seven     = "seven"~     => [[ 7 ]]
  eight     = "eight"~     => [[ 8 ]]
  nine      = "nine"~      => [[ 9 ]]
  ten       = "ten"~       => [[ 10 ]]
  eleven    = "eleven"~    => [[ 11 ]]
  twelve    = "twelve"~    => [[ 12 ]]
  thirteen  = "thirteen"~  => [[ 13 ]]
  fourteen  = "fourteen"~  => [[ 14 ]]
  fifteen   = "fifteen"~   => [[ 15 ]]
  sixteen   = "sixteen"~   => [[ 16 ]]
  seventeen = "seventeen"~ => [[ 17 ]]
  eighteen  = "eighteen"~  => [[ 18 ]]
  nineteen  = "nineteen"~  => [[ 19 ]]
  twenty    = "twenty"~    => [[ 20 ]]
  thirty    = "thirty"~    => [[ 30 ]]
  forty     = "forty"~     => [[ 40 ]]
  fifty     = "fifty"~     => [[ 50 ]]
  sixty     = "sixty"~     => [[ 60 ]]
  seventy   = "seventy"~   => [[ 70 ]]
  eighty    = "eighty"~    => [[ 80 ]]
  ninety    = "ninety"~    => [[ 90 ]]
  hundred   = "hundred"~   => [[ 100 ]]
  thousand  = "thousand"~  => [[ 1000 ]]
  million   = "million"~   => [[ 6 10^ ]]
  billion   = "billion"~   => [[ 9 10^ ]]
  trillion  = "trillion"~  => [[ 12 10^ ]]

  quadrillion = "quadrillion"~ => [[ 15 10^ ]]
  quintillion = "quintillion"~ => [[ 18 10^ ]]
  sextillion  = "sextillion"~  => [[ 21 10^ ]]
  septillion  = "septillion"~  => [[ 24 10^ ]]
  octillion   = "octillion"~   => [[ 27 10^ ]]
  nonillion   = "nonillion"~   => [[ 30 10^ ]]
  decillion   = "decillion"~   => [[ 33 10^ ]]
  undecillion = "undecillion"~ => [[ 36 10^ ]]

  duodecillion      = "duodecillion"~      => [[ 39 10^ ]]
  tredecillion      = "tredecillion"~      => [[ 42 10^ ]]
  quattuordecillion = "quattuordecillion"~ => [[ 45 10^ ]]
  quindecillion     = "quindecillion"~     => [[ 48 10^ ]]
  sexdecillion      = "sexdecillion"~      => [[ 51 10^ ]]
  septendecillion   = "septendecillion"~   => [[ 54 10^ ]]
  octodecillion     = "octodecillion"~     => [[ 57 10^ ]]
  novemdecillion    = "novemdecillion"~    => [[ 60 10^ ]]
  vigintillion      = "vigintillion"~      => [[ 63 10^ ]]

  name      = vigintillion|novemdecillion|octodecillion|
              septendecillion|sexdecillion|quindecillion|
              quattuordecillion|tredecillion|duodecillion|
              undecillion|decillion|nonillion|octillion|
              septillion|sextillion|quintillion|quadrillion|
              trillion|billion|million|thousand|hundred|ninety|
              eighty|seventy|sixty|fifty|forty|thirty|twenty|
              nineteen|eighteen|seventeen|sixteen|fifteen|
              fourteen|thirteen|twelve|eleven|ten|nine|eight|
              seven|six|five|four|three|two|one

  ws        = [\n\t\r ]* => [[ drop ignore ]]
  dual      = name "-"~ name => [[ sum ]]
  atom      = dual|name
  atoms     = (ws atom ws)+ => [[ product ]]
  compound  = atoms "and"~ ws atom ws name ws
            => [[ first3 swap over [ * ] 2bi@ 2array ]]
  simple    = atoms "and"~ ws atom ws
  basic     = "and"~ ws atom ws
  group     = compound|simple|basic|atoms
  natural   = (group (","~)? )+
            => [[ flatten dup check-natural sum ]]

  negative  = "negative"~ ws natural => [[ -1 * ]]
  zero      = "zero"~ => [[ 0 ]]
  integer   = zero|negative|natural

  fraction  = integer "divided by"~ natural => [[ first2 / ]]

  digit     = nine|eight|seven|six|five|four|three|two|one|zero
  mantissa  = (ws digit ws)+
            => [[ [ number>string ] map concat ]]
  decimal   = integer ws "point"~ mantissa
            => [[ first2 [ number>string ] dip "." glue string>number ]]

  number    = fraction|decimal|integer
]=]


: names-to-numbers-demo ( -- )
    {
        "zero"
        "one"
        "negative one"
        "nine"
        "ten"
        "negative seventeen"
        "twenty-seven"
        "one hundred"
        "one hundred and one"
        "negative one hundred and nineteen"
        "four hundred and ninety-five thousand, three hundred and thirty-three"
        "two hundred million"
        "two hundred million and twenty-two"
        "two hundred million, two thousand and two"
        "one trillion, one billion, one million, one thousand and one"
        "four hundred and fifty-three vigintillion"
        "zero point one"
        "one point one"
        "negative one thousand, three hundred point zero zero five six seven"
        "thirty-seven divided by ninety-one"
        "zero divided by two nonillion"
        "negative one divided by two nonillion"
    }
    [ dup text>number "%s => %u\n" printf ] each ;

names-to-numbers-demo
