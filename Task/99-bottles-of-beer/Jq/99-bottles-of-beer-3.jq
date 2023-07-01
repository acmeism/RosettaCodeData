def sing:
  def s: if . == 1 then "" else "s" end;
  def bottles:
    if . == 0 then "No more"
    else "\(.)"
    end + " bottle\(s)";
  (. - range(0;.+1) )
  | "
\(bottles) of beer on the wall
\(bottles) of beer
Take one down, pass it around
\(bottles) of beer on the wall."
;

$bottles | tonumber | sing
