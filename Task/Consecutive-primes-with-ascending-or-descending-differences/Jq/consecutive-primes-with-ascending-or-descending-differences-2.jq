# Input: null or limit+1
# Output: informative strings
def longestSequences:
  [primes] as $primes
  | def longestSeq(direction):
      { pd: 0,
        longSeqs: [[2]],
        currSeq: [2] }
      | reduce range( 1; $primes|length) as $i (.;
          ($primes[$i] - $primes[$i-1]) as $d
          | if (direction == "ascending" and $d <= .pd) or (direction == "descending" and $d >= .pd)
            then if (.currSeq|length) > (.longSeqs[0]|length)
                 then .longSeqs = [.currSeq]
                 else if (.currSeq|length) == (.longSeqs[0]|length)
                      then .longSeqs += [.currSeq]
                      else .
                      end
                 end
             | .currSeq = [$primes[$i-1], $primes[$i]]
             else .currSeq += [$primes[$i]]
             end
          | .pd = $d
      )
      | if (.currSeq|length) > (.longSeqs[0]|length)
        then .longSeqs = [.currSeq]
        else if (.currSeq|length) == (.longSeqs[0]|length)
             then .longSeqs = .longSeqs + [.currSeq]
             else .
             end
        end

      | "Longest run(s) of primes with \(direction) differences is \(.longSeqs[0]|length):",
        (.longSeqs[] as $ls
         | add( range(1; $ls|length) | [$ls[.] - $ls[.-1]]) as $diffs
         | add( range(0; $ls|length-1) | "\($ls[.]) (\($diffs[.])) ") + "\($ls[-1])" );

      longestSeq("ascending"), "", longestSeq("descending");

"For primes < 1 million:",
 ( 1E6 | longestSequences )
