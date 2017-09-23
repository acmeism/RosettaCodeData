def hickerson:
  . as $n
  | (2|log) as $log2
  | reduce range(1;$n+1) as $i ( 0.5/$log2; . * $i / $log2) ;

def precise:
   (. - 0.05) as $x | . != ($x + 0.1) ;

def almost_an_integer:
  tostring
  | index(".") as $ix
  | if $ix == null then true
    else .[$ix+1:$ix+2] | (. == "9" or . == "0")
    end ;

range(1;18)
  | . as $i
  | hickerson
  | if precise then
      if almost_an_integer
        then "hickerson(\($i)) is \(.) -- almost an integer"
      else "hickerson(\($i)) is \(.)"
      end
    else "insufficient precision for hickerson(\($i))"
    end
