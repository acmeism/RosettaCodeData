def isinteger: test("^ *[+-]?[0-9]+ *$");

def soloway:
  label $out
  | foreach (inputs, null) as $x (null;
      .invalid = false
      | if $x == null then .break = true
        elif ($x|isinteger) then ($x|tonumber) as $n
        | if $n == 99999
          then .break = true
          else .sum += $n | .n += 1
          end
        else .invalid = $x
        end;
      if .break then ., break $out
      elif .invalid then .
      else empty
      end)
  | (select(.invalid) | "Invalid entry (\(.invalid)). Please try again."),
    (select(.break and .sum) | "Average is: \(.sum / .n)") ;

soloway
