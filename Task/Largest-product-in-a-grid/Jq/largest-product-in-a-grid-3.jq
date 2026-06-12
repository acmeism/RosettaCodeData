# Input: a row
# Output: [$i, $maxproduct]
def largest_product_of_row($size):
   [range(0; 1 + length - $size) as $i
    | [$i, (.[$i:$i+$size] | prod)] ] | max_by(.[1]);

# Input: a matrix
def largest_product_of_rows($size):
  [range(0; length) as $row
   | [$row, (.[$row] | largest_product_of_row($size)) ]] | max_by(.[1][1])
   | [ .[0], .[1][]] ;

# Input: a matrix
def largest_product_with_details($size):
  largest_product_of_rows($size) as [$row, $rowcol, $rmax]
  | (transpose | largest_product_of_rows($size)) as [$col, $colrow, $cmax]
  | if $rmax == $cmax
    then "row-wise at \([$row, $rowcol]) equals col-wise at \([$col, $colrow]): \($cmax)"
    elif $rmax > $cmax then "The rows have it at \([$row, $rowcol]): \($rmax)"
    else                 "The columns have it at \([$colrow, $col]): \($cmax)"
    end ;

grid | largest_product_with_details(4)
