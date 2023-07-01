def tests:  [
  "A xor B",
  "notA",
  "A and B",
  "A and B or C",
  "A=>(notB)",
  "A=>(A => (B or A))",
  "A xor B and C"
];

def tables:
  tests[] as $test
  | ($test | statement | .result)
  | . as $result
  | vars as $vars
  | ($vars + [" ", $test] | join(" ") | underscore),
    (($vars | vars2tf)
     | ( [.[], " ", eval($result) | TF] | join(" ")) ),
    ""
   ;

tables
