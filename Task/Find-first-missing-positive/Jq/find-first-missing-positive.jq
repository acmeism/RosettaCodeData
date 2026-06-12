# input: an array of integers
def first_missing_positive:
  INDEX(.[]; tostring) as $dict
  | first(range(1; infinite)
          | . as $n
	  | select($dict|has($n|tostring)|not) ) ;

def examples:
 [1,2,0], [3,4,-1,1], [7,8,9,11,12], [-5, -2, -6, -1];

# The task:
examples
| "\(first_missing_positive) is missing from \(.)"
