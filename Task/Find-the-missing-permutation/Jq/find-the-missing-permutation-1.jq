def transpose:
  if (.[0] | length) == 0 then []
  else [map(.[0])] + (map(.[1:]) | transpose)
  end ;

# Input:  an array of integers (based on the encoding of A=0, B=1, etc)
#         corresponding to the occurrences in any one position of the
#         letters in the list of permutations.
# Output: a tally in the form of an array recording in position i the
#         parity of the number of occurrences of the letter corresponding to i.
# Example: given [0,1,0,1,2], the array of counts of 0, 1, and 2 is [2, 2, 1],
#          and thus the final result is [0, 0, 1].
def parities:
  reduce .[] as $x ( []; .[$x] = (1 + .[$x]) % 2);

# Input: an array of parity-counts, e.g. [0, 1, 0, 0]
# Output: the corresponding letter, e.g. "B".
def decode:
  [index(1) + 65] | implode;

# encode a string (e.g. "ABCD") as an array (e.g. [0,1,2,3]):
def encode_string: [explode[] - 65];
