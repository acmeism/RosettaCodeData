# Let R[n] be the Recaman sequence, n >= 0, so R[0]=0.
# Input: a number, $required, specifying the required range of integers, [1 .. $required]
#        to be covered by R[0] ... R[.n]
# $capture: the number of elements of the sequence to retain.
# Output: an object as described below.
# Note that .a|length will be equal to $capture.
#
def recaman_required($capture):
  . as $required
  | {
      n: 0,
      current: 0,                 # R[.n]
      previous: null,             # R[.n-1]
      a: [0],                     # only maintained up to a[$capture-1]
      used:  { "0": true },       # hash for checking whether a value has already occurred
      found: { "0": true },       # hash for checking how many in [0 .. $required] inclusive have been found
      nfound: 1,                  # .found|length
      foundDup: null,             # the first duplicated entry in the sequence
      foundDupAt: null            # .foundDup == R[.foundDupAt]
     }
  | until ((.n >= $capture) and .foundDup and (.nfound > $required);
      .n += 1
      | .current -= .n
      | if (.current < 1 or .used[.current|tostring]) then .current = .current + 2*.n else . end
      | (.current|tostring) as $s
      | .used[$s] as $alreadyUsed
      | if .n < $capture then .a += [.current] else . end
      | if ($alreadyUsed|not)
        then .used[$s] = true
	| if (.current >= 0 and .current <= $required)
	  then .found[$s] = true | .nfound+=1
	  else . end
        else .
	end
      | if (.foundDup|not) and $alreadyUsed
        then .foundDup = .current
	| .foundDupAt = .n
        else .
	end );
	
1000 as $required
| 15 as $capture
| $required | recaman_required($capture)
| "The first \($capture) terms of Recaman's sequence are: \(.a)",
  "The first duplicated term is a[\(.foundDupAt)] = \(.foundDup)",
  "Terms up to a[\(.n)] are needed to generate 0 to \($required) inclusive."
