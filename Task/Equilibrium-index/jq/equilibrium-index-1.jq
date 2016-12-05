# The index origin is 0 in jq.
def equilibrium_indices:
  def indices(a; mx):
    def report: # [i, headsum, tailsum]
      .[0] as $i
      | if $i == mx then empty          # all done
        else .[1] as $h
        | (.[2] - a[$i]) as $t
        | (if $h == $t then $i else empty end),
          ( [ $i + 1, $h + a[$i], $t ] | report )
        end;
    [0, 0, (a|add)] | report;
  . as $in | indices($in; $in|length);
