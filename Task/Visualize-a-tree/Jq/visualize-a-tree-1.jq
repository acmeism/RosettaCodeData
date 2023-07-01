# Input: an array representing a tree
# Output: a stream of strings representing the tree
# In this implementation, empty arrays in the tree are simply ignored.
def printTree:

  def tidy:
    sub("└─$"; "  ")
    | sub("├─$"; "| ") ;

  # Input: a string prefix
  def print($tree):
    if $tree|type != "array" then . + ($tree|tostring)
    else # ignore empty arrays
    ($tree | map(select(if type == "array" then length>0 else true end))) as $tree
    | if $tree|length == 0 then empty
      elif $tree|length == 1
      then print($tree[0])
      else print($tree[0]),
           ($tree[1:] as $children
            | tidy as $p
             | ($p + ( "├─" | print($children[:-1][]))),
               ($p + ( "└─" | print($children[-1]))) )
      end
    end ;

  . as $tree
  | "" | print($tree) ;
