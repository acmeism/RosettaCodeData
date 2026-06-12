def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# For formatting numbers
# ... but leave non-numbers, 0, and numbers using E alone
def round($dec):
  def rpad($len): tostring | ($len - length) as $l | . + ("0" * $l);
   if type == "string" then .
   elif . == 0 then "0"
   else pow(10;$dec) as $m
   | . * $m | round / $m
   | tostring
   | (capture("(?<n>^[^.]*[.])(?<f>[0-9]*$)")
      | .n + (.f|rpad($dec)))
     // if test("^[0-9]+$") then . + "." + ("" | rpad($dec)) else null end
     // .
   end;
