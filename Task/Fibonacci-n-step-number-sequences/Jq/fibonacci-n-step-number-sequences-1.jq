# Input: the initial array
def nacci(arity; len):
  arity as $arity | len as $len
  | reduce range(length; $len) as $i
      (.;
       ([0, (length - $arity)] | max ) as $lower
       | . + [ .[ ($lower) : length] | add] ) ;

def fib(arity; len):
  arity as $arity | len as $len
  | [1,1] | nacci($arity; $arity) | nacci($arity; $len) ;

def lucas(arity; len):
  arity as $arity | len as $len
  | [2,1] | nacci($arity; $arity) | nacci($arity; $len) ;
