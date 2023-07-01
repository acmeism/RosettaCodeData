# remove words with fewer than 3 or more than 9 letters
def words: inputs | select(length | . > 2 and . < 10);

# The central letter in `puzzle` should be the central letter of the word wheel
def solve(puzzle):
  def chars: explode[] | [.] | implode;
  def profile(s): reduce s as $c (null; .[$c] += 1);
  profile(puzzle[]) as $profile
  | def ok($prof): all($prof|keys_unsorted[]; . as $k | $prof[$k] <= $profile[$k]);
  (puzzle | .[ (length - 1) / 2]) as $central
  | words
  | select(index($central) and ok( profile(chars) )) ;

"The solutions to the puzzle are as follows:",
solve( ["d", "e", "e", "g", "k", "l", "n", "o", "w"] )
