# "next" allows one to generate successive leaves, one at a time. This is accomplished
# by ensuring that the non-null output of a call to "next" can also serve as input.
#
# "next" returns null if there are no more leaves, otherwise it returns [leaf, nodes]
# where "leaf" is the next leaf, and nodes is an array of nodes still to be traversed.
# Input has the same form, but on input, "leaf" is ignored unless it is an array.
def next:
 def _next:
     .[0] as $node | .[1] as $nodes
      | if ($node|type) == "array" then
          if $node|length != 2 then
            error("improper node: \($node) should have 2 items") else . end
          | [ $node[0],  [$node[1]] + $nodes]
        elif $nodes|length > 0 then  [$nodes[0], $nodes[1:]]
        else null
        end;
  _next as $n
  | if $n == null then null
    elif ($n[0]|type) == "array" then $n|next
    else $n
    end;

# t and u must be binary trees
def same_fringe(t;u):
  # x and y must be suitable for input to "next"
  def eq(x;y):
    if x == null then y == null
    elif y == null then false
    elif x[0] != y[0] then false
    else eq( x|next;  y|next)
    end;

   eq([t,[]]|next; [u,[]]|next) ;
