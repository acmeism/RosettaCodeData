# listof( stream; criterion) constructs an array of those
# elements in the stream that satisfy the criterion
def listof( stream; criterion): [ stream|select(criterion) ];

def listof_triples(n):
  listof( range(1;n+1) as $x | range($x;n+1) as $y | range($y;n+1) as $z
          | [$x, $y, $z];
          .[0] * .[0] +  .[1] * .[1] ==  .[2] * .[2] ) ;

listof_triples(20)
