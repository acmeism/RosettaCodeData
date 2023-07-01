# The input is used to initialize the elements of the
# multi-dimensional array:
def multiarray(d):
  . as $in
  | if (d|length) == 1 then [range(0;d[0]) | $in]
    else multiarray(d[1:]) | multiarray( d[0:1] )
    end;
