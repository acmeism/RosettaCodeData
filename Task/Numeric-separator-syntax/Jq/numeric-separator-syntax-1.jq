# The def of _nwise/1 can be omitted if using the C implementation of jq.
def _nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

# commatize/0 and commatize/1 are intended for integers or integer-valued strings,
# where integers of the form [-]?[0-9]*[Ee][+]?[0-9]+ are allowed.
# Notice that a leading '+' is disallowed, as is an exponent of the form '-0'.
# Output: a string
def commatize($comma):
  def c: [explode | reverse | _nwise(3) | reverse | implode] | reverse | join($comma);
  def e: "unable to commatize: " + tostring | error;

  if type == "string"
  then if test("^[0-9]+$") then c
       elif test("^-[0-9]+$") then "-" + .[1:] | c
       else (capture("(?<s>[-])?(?<i>[0-9]*)[Ee][+]?(?<e>[0-9]+)$") // null)
       | if .
         then if .i == "" then .i="1" else . end
         | .s |= (if . = null then "" else . end)
         | .s + ((.i + (.e|tonumber) * "0") | c)
         else e
         end
       end
  elif type == "number" and . == floor
  then if . >= 0
       then tostring|commatize($comma)
       else "-" + (-. | tostring | commatize($comma) )
       end
  else e
  end;

def commatize:
  commatize(",");
