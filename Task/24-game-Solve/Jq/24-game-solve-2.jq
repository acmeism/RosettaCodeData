# Evaluate the input, which must be a number or a triple: [x, op, y]
def eval:
  if type == "array" then
    .[1] as $op
    | if .[0] == null or .[2] == null then null
      else
       (.[0] | eval) as $left | (.[2] | eval) as $right
       | if $left == null or $right == null then null
        elif  $op == "+" then $left + $right
        elif  $op == "-" then $left - $right
        elif  $op == "*" then $left * $right
        elif  $op == "/" then
          if $right == 0 then null
  	  else $left / $right
	  end
        else "invalid arithmetic operator: \($op)" | error
	end
      end
  else .
  end;

def pp:
  "\(.)" | explode | map([.] | implode | if . == "," then " " elif . == "\"" then "" else . end) | join("");
