# Solution for n doors:
def doors(n):

  def print:
    . as $doors
    | range(1; length+1)
    | if $doors[.] then "Door \(.) is open" else empty end;

    [range(n+1)|null] as $doors
  | reduce range(1; n+1) as $run
      ( $doors; reduce range($run; n+1; $run ) as $door
                  ( .; .[$door] = (.[$door] | not) ) )
  | print ;
