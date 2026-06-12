def countEquals($n; s):
  label $out
  | foreach (s, null) as $x (-1;
      . + 1;
      if $x == null then . == $n
      elif . > $n then false, break $out
      else empty
      end);

range(1;1000)
| select( tostring
          | countEquals(2; select(explode[] == 49))) # "1"
