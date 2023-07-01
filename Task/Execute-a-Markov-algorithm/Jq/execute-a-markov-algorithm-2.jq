def parseRules($rules):
  "^ *(?<period>[.]?) *(?<rule>.*)" as $pattern
  | reduce $rules[] as $rule ([];
      if $rule | (startswith("#") or (test(" -> ")|not)) then .
      else ($rule|split2(" -> ")) as $splits
      | ($splits[1] | capture($pattern)) as $re
      | . + [[($splits[0]|trim|deregex), $re.period, ($re.rule | trim)]]
      end );

# applyRules applies $rules to . recursively,
# where $rules is the set of applicable rules in the form of an array-of-triples.
# Input and output: a string
def applyRules($rules):
  # The inner function has arity-0 for efficiency
  # input and output: {stop, string}
  def apply:
    if .stop then .
    else .string as $copy
    | first( foreach $rules[] as $c (.;
               .string |= sub($c[0]; $c[2])
               | if $c[1] == "."
                 then .stop=true
                 elif .string != $copy
                 then (apply | .stop = true)
                 else .
                 end;
               if .stop then . else empty end))
      // .
    end;
    {stop: false, string: .} | apply | .string;

def proceed:
  rules as $rules
  | tests as $tests
  | range(0; $tests|length) as $ix
  | $tests[$ix]
  | "  \(.)\n=>\(applyRules( parseRules( $rules[$ix] ) ))\n" ;

proceed
