# merge input array with array x by comparing the heads of the arrays
# in turn; # if both arrays are sorted, the result will be sorted:
def merge(x):
  length as $length
  | (x|length) as $xl
  | if $length == 0 then x
    elif $xl == 0 then .
    else
      . as $in
      | reduce range(0; $xl + $length) as $z
         # state [ix, xix, ans]
         ( [0, 0, []];
           if .[0] < $length and
              ((.[1] < $xl and $in[.[0]] <= x[.[1]]) or .[1] == $xl)
           then [(.[0] + 1), .[1], (.[2] + [$in[.[0]]]) ]
           else [.[0], (.[1] + 1), (.[2] + [x[.[1]]]) ]
           end
         ) | .[2]
    end ;

def strand_sort:
  # The inner function emits [strand, remainder]
  def strand:
    if length <= 1 then .
    else
      reduce .[] as $x
      # state: [strand, remainder]
      ([ [], [] ];
       if ((.[0]|length) == 0) or .[0][-1] <= $x
       then [ (.[0] + [$x]), .[1] ]
       else [ .[0], (.[1] + [$x]) ]
       end )
    end ;

  if length <= 1 then .
  else strand as $s
    | ($s[0] | merge( $s[1] | strand_sort))
  end ;
