# Create an m x n matrix
 def matrix(m; n; init):
   if m == 0 then []
   elif m == 1 then [range(0;n)] | map(init)
   elif m > 0 then
     matrix(1;n;init) as $row
     | [range(0;m)] | map( $row )
   else error("matrix\(m);_;_) invalid")
   end ;

# Print a matrix neatly, each cell occupying n spaces
def neatly(n):
  def right: tostring | ( " " * (n-length) + .);
  . as $in
  | length as $length
  | reduce range (0;$length) as $i
      (""; . + reduce range(0;$length) as $j
      (""; "\(.) \($in[$i][$j] | right )" ) + "\n" ) ;
