# Input: the target number of Ulam numbers to generate
# Output: an array of Ulam numbers
def ulams:
  . as $target
  | label $done
  | {ulam: [1, 2],
     nulams: 2}
  | foreach range(3; infinite) as $n (.;
      .count = 0
      | .x = 0
      | until( .x == .nulams or .count > 1;
          .y = .x+1
	  | until( .y >= .nulams or .count > 1;
              if (.ulam[.x] + .ulam[.y] == $n) then .count += 1 else . end
	      | .y += 1)
	   | .x += 1)

       | if .count == 1 then .nulams += 1 | .ulam[.nulams-1] = $n else . end;
       select(.nulams >= $target) | .ulam, break $done);

def nth_ulam: ulams[.-1];
