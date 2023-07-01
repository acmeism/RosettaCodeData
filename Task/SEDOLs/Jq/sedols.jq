def ascii_upcase:
  explode | map( if 97 <= . and . <= 122 then . - 32  else . end) | implode;

def sedol_checksum:
  def encode(a): 10 + (a|explode[0]) - ("A"|explode[0]);
  . as $sed
  | [1,3,1,7,3,9] as $sw
  | reduce range(0;6) as $i
      (0;
       $sed[$i:$i+1] as $c
       | if ( "0123456789" | index($c) )
         then . + ($c|tonumber) * $sw[$i]
         else . + encode($c) * $sw[$i]
         end )
  | (10 - (. % 10)) % 10 ;

# error on error, else pass input to output
def check_valid_sedol:
  def has_vowel:
    ("AEIOU"|explode) as $vowels
    | reduce explode[] as $c
        (false; if . then . else $vowels|index($c) end);

  if has_vowel then error( "\(.) is not a valid SEDOL code" )
  else .
  end
  | if length > 7 or length < 6 then
      error( "\(.) is too long or too short to be valid SEDOL")
    else .
    end;

def sedolize:
  ascii_upcase as $in
  | $in
  | check_valid_sedol
  | .[0:6] as $sedol
  | ($sedol | sedol_checksum | tostring) as $sedolcheck
  | ($sedol + $sedolcheck) as $ans
  | if length == 7 and $ans != $in then
         $ans + " (original \($in) has wrong checksum digit"
    else $ans
    end ;
sedolize
