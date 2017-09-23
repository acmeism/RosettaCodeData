# Input: [x,y] -- the two arrays to be merged
# If x and y are sorted as by "sort", then the result will also be sorted:
def merge:
  def m:  # state: [x, y, array]  (array being the answer)
    .[0] as $x
    | .[1] as $y
    | if   0 == ($x|length) then .[2] + $y
      elif 0 == ($y|length) then .[2] + $x
      else
        (if $x[0] <= $y[0] then [$x[1:], $y,     .[2] + [$x[0] ]]
         else                   [$x,     $y[1:], .[2] + [$y[0] ]]
         end) | m
      end;
   [.[0], .[1], []] | m;

def merge_sort:
  if length <= 1 then .
  else
    (length/2 |floor) as $len
    | . as $in
    | [ ($in[0:$len] | merge_sort), ($in[$len:] | merge_sort) ] | merge
  end;
