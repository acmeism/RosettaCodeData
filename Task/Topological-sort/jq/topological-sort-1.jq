# independent/0 emits an array of the dependencies that have no dependencies
# Input: an object representing a normalized dependency graph
def independent:
  . as $G
  | reduce keys[] as $key
      ([];
       . +  ((reduce $G[$key][] as $node
               ([];
                if ($G[$node] == null or ($G[$node]|length)==0) then . + [$node]
                else .
                end ))))
  | unique;

# normalize/0 eliminates self-dependencies in the input dependency graph.
# Input: an object representing a dependency graph.
def normalize:
  . as $G
  | reduce keys[] as $key
      ($G;
       .[$key] as $nodes
       | if $nodes and ($nodes|index($key)) then .[$key] = $nodes - [$key] else . end);


# minus/1 removes all the items in ary from each of the values in the input object
# Input: an object representing a dependency graph
def minus(ary):
  . as $G | reduce keys[] as $key ($G; $G[$key] -= ary);

# tsort/0 emits the topologically sorted nodes of the input,
# in ">" order.
# Input is assumed to be an object representing a dependency
# graph and need not be normalized.
def tsort:
  # _sort: input: [L, Graph], where L is the tsort so far
  def _tsort:

    def done: [.[]] | all( length==0 );

    .[0] as $L | .[1] as $G
    | if ($G|done) then $L + (($G|keys) - $L)
      else
         ($G|independent) as $I
         | if (($I|length) == 0)
           then error("the dependency graph is cyclic: \($G)")
           else [ ($L + $I), ($G|minus($I))] | _tsort
           end
      end;

  normalize | [[], .] | _tsort ;

tsort
