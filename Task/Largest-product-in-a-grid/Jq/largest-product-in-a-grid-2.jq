# Input: a matrix
def largest_product($size):
   ([.[] |  (windows($size) | prod)] | max) as $rowmax
   |  ([transpose[] | (windows($size) | prod)] | max) as $colmax
   | [$rowmax, $colmax]|max,
     if ($rowmax > $colmax) then "The rows have it." else "The columns
   have it." end ;

grid | largest_product(4)
