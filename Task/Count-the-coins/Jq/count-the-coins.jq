# How many ways are there to make "target" cents, given a list of coin
# denominations as input.
# The strategy is to record at total[n] the number of ways to make n cents.
def countcoins(target):
  . as $coin
  | reduce range(0; length) as $a
      ( [1] + [range(0, target)|0];   # there is 1 way to make 0 cents
        reduce range(1; target + 1) as $b
          (.;                                      # total[]
           if $b < $coin[$a] then .
           else  .[$b - $coin[$a]] as $count
           | if $count == 0 then .
             else .[$b] += $count
             end
           end ) )
  | .[target] ;

### Examples:
([1,5,10,25] | countcoins(100)),
([1, 5, 10, 25, 50, 100] | countcoins(100000))
