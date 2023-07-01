def capitalize:
  if length==0 then .
  else .[0:1] as $c
  | ($c|ascii_upcase) as $C
  | if $c == $C then .
    else $C + .[1:]
    end
  end;

def printVerse:
  {x: (ascii_downcase|capitalize)}
  | .x[0:1] as $x0
  | .y = (if $x0|test("[AEIOU]") then .x | ascii_downcase else .x[1:] end)
  | .b = ((select($x0 == "B") | "") // "b")
  | .f = ((select($x0 == "F") | "") // "f")
  | .m = ((select($x0 == "M") | "") // "m")
  | "\(.x), \(.x), bo-\(.b)\(.y)",
   "Banana-fana fo-\(.f)\(.y)",
   "Fee-fi-mo-\(.m)\(.y)",
   "\(.x)!\n" ;

"Gary", "Earl", "Billy", "Felix", "Mary", "Steve"
| printVerse
