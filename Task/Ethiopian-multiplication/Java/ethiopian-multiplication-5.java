def halve: (./2) | floor;

def double: 2 * .;

def isEven: . % 2 == 0;

def ethiopian_multiply(a;b):
  def pairs: recurse( if .[0] > 0
                      then [ (.[0] | halve), (.[1] | double) ]
                      else empty
                      end );
  reduce ([a,b] | pairs
          | select( .[0] | isEven | not)
          | .[1] ) as $i
    (0; . + $i) ;
