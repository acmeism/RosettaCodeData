# How many ways are there to make "target" cents, given a list of coin
# denominations as input.
# The strategy is to record at total[n] the number of ways to make n cents.
def countcoins(target):
  . as $coin
  | reduce range(0; length) as $a
      ( [1];   # there is 1 way to make 0 cents
        reduce range(1; target + 1) as $b
          (.;                                      # total[]
           if $b < $coin[$a] then .
           else  .[$b - $coin[$a]] as $count
           | if $count == 0 then .
             else .[$b] += $count
             end
           end ) )
  | .[target] ;
