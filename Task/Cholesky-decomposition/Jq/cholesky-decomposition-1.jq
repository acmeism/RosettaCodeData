# Create an m x n matrix
 def matrix(m; n; init):
   if m == 0 then []
   elif m == 1 then [range(0; n)] | map(init)
   elif m > 0 then
     matrix(1; n; init) as $row
     | [range(0; m)] | map( $row )
   else error("matrix\(m);_;_) invalid")
   end ;

# Print a matrix neatly, each cell ideally occupying n spaces,
# but without truncation
def neatly(n):
  def right: tostring | ( " " * (n-length) + .);
  . as $in
  | length as $length
  | reduce range (0; $length) as $i
      (""; . + reduce range(0; $length) as $j
      (""; "\(.) \($in[$i][$j] | right )" ) + "\n" ) ;

def is_square:
  type == "array" and (map(type == "array") | all) and
    length == 0 or ( (.[0]|length) as $l | map(length == $l) | all) ;

# This implementation of is_symmetric/0 uses a helper function that circumvents
# limitations of jq 1.4:
def is_symmetric:
    # [matrix, i,j, len]
    def test:
       if .[1] > .[3] then true
       elif .[1] == .[2] then [ .[0], .[1] + 1, 0, .[3]] | test
       elif .[0][.[1]][.[2]] == .[0][.[2]][.[1]]
         then [ .[0], .[1], .[2]+1, .[3]] | test
      else false
      end;
    if is_square|not then false
    else [ ., 0, 0, length ] | test
    end ;
