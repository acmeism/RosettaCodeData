# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# Returns (. ^ $exp) % $mod
# where $exp >= 0, $mod != 0, and the input are integers.
def modPow($exp; $mod):
  if $mod == 0 then "Cannot take modPow with modulus 0." | error
  elif $exp < 0 then "modPow with exp < 0 is not supported." | error
  else . as $x
  | {r: 1, base: ($x % $mod), exp: $exp}
  | until( .exp <= 0 or .emit;
         if .base == 0 then .emit = 0
         else if .exp%2 == 1
              then .r = (.r * .base) % $mod
	      |    .exp |= (. - 1) / 2
	      else .exp /= 2
	      end
         | .base |= (. * .) % $mod
 	 end )
  | if .emit then .emit else .r end
  end;

def task:
    2988348162058574136915891421498819466320163312926952423791023078876139 as $a
  | 2351399303373464486466122544523690094744975233415544072992656881240319 as $b
  | (10|power(40)) as $m
  | $a | modPow($b; $m) ;

task
