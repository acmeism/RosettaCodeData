# maximal_initial_subarray takes as input an array of arrays:
def maximal_initial_subarray:
  (map( .[0] ) | unique) as $u
  | if $u == [ null ] then []
    elif ($u|length) == 1
    then  $u  + ( map( .[1:] ) | maximal_initial_subarray)
    else []
    end ;

# Solution: read in the strings, convert to an array of arrays, and proceed:
def common_path(slash):
  [.[] | split(slash)] | maximal_initial_subarray | join(slash) ;

common_path("/")
