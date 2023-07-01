# Generate a stream of solutions.
# Input should be the connections array, i.e. an array of [i,j] pairs;
# N is the number of pegs and holds.
def solutions(N):
  def abs: if . < 0 then -. else . end;

  # Is the proposed permutation (the input) ok?
  def ok(connections):
    . as $p
    | all( connections[];
           (($p[.[0]] - $p[.[1]])|abs) != 1 );

   . as $connections | permutations(N) | select(ok($connections));
