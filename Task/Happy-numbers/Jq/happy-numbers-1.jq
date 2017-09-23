def is_happy_number:
  def next: tostring | explode | map( (. - 48) | .*.) | add;
  def last(g): reduce g as $i (null; $i);
  # state: either 1 or [i, o]
  # where o is an an object with the previously encountered numbers as keys
  def loop:
   recurse( if      . == 1 then empty    # all done
            elif .[0] == 1 then 1        # emit 1
            else (.[0]| next) as $n
            | if $n == 1 then 1
              elif .[1]|has($n|tostring) then empty
              else [$n, (.[1] + {($n|tostring):true}) ]
              end
            end );
  1 == last( [.,{}] | loop );
