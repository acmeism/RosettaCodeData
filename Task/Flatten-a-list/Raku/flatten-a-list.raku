my @l = [[1], 2, [[3,4], 5], [[[]]], [[[6]]], 7, 8, []];

say .perl given gather @l.deepmap(*.take); # lazy recursive version

# Another way to do it is with a recursive function (here actually a Block calling itself with the &?BLOCK dynamic variable):

say { |(@$_ > 1 ?? map(&?BLOCK, @$_) !! $_) }(@l)
