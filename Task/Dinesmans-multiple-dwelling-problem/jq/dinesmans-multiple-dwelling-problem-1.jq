# Input: an array representing the apartment house, with null at a
#    particular position signifying that the identity of the occupant
#    there has not yet been determined.
# Output: an elaboration of the input array but including person, and
#   satisfying cond, where . in cond refers to the placement of person
def resides(person; cond):
  range(0;5) as $n
  | if (.[$n] == null or .[$n] == person) and ($n|cond) then .[$n] = person
    else empty   # no elaboration is possible
    end ;

# English:
def top: 4;
def bottom: 0;
def higher(j): . > j;
def adjacent(j): (. - j) | (. == 1 or . == -1);
