def is_rep_string:
  # if self is a rep-string then return [n, prefix]
  # where n is the number of full occurrences of prefix
  def _check(prefix; n; sofar):
    length as $length
    | if length <= (sofar|length) then [n, prefix]
      else (sofar+prefix) as $sofar
      | if  startswith($sofar) then _check(prefix; n+1; $sofar)
        elif ($sofar|length) > $length and
             startswith($sofar[0:$length]) then [n, prefix]
        else [0, prefix]
        end
      end
  ;

  [range (1; length/2 + 1) as $i
     | .[0:$i] as $prefix
     | _check($prefix; 1; $prefix)
     | select( .[0] > 1 ) ]
  ;
