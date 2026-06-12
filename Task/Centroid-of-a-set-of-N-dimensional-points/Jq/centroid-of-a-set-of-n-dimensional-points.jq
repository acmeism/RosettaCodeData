# Input: an array of points of the same dimension (i.e. numeric arrays of the same length)
def centroid:
  length as $n
  | if ($n == 0) then "centroid: list must contain at least one point." | error else . end
  | (.[0]|length) as $d
  | if any( .[]; length != $d )
    then "centroid: points must all have the same dimension." | error
    else .
    end
  | transpose
  | map( add / $n ) ;

def points: [
    [ [1], [2], [3] ],
    [ [8, 2], [0, 0] ],
    [ [5, 5, 0], [10, 10, 0] ],
    [ [1, 3.1, 6.5], [-2, -5, 3.4], [-7, -4, 9], [2, 0, 3] ],
    [ [0, 0, 0, 0, 1], [0, 0, 0, 1, 0], [0, 0, 1, 0, 0], [0, 1, 0, 0, 0] ]
 ];

points[]
| "\(.) => Centroid: \(centroid)"
