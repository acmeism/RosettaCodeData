# The connectedness matrix:
# In this table, 0 represents "A", etc, and an entry [i,j]
# signifies that the holes with indices i and j are connected.
def connections:
  [[0, 2], [0, 3], [0, 4],
   [1, 3], [1, 4], [1, 5],
   [6, 2], [6, 3], [6, 4],
   [7, 3], [7, 4], [7, 5],
   [2, 3], [3, 4], [4, 5]]
;

def solve:
  connections | solutions(8);

# pretty-print a solution for the 8-peg puzzle
def pp:
  def pegs: ["A", "B", "C", "D", "E", "F", "G", "H"];
  . as $in
  | ("
         A   B
        /|\\ /|\\
       / | X | \\
      /  |/ \\|  \\
     C - D - E - F
      \\  |\\ /|  /
       \\ | X | /
        \\|/ \\|/
         G   H
"   | explode) as $board
    | (pegs | map(explode)) as $letters
    | $letters
    | reduce range(0;length) as $i ($board; index($letters[$i]) as $ix | .[$ix] = $in[$i] + 48)
    | implode;
