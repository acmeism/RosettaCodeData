# $limit is the target number of Sisyphus numbers to find and should be at least 100
def task($limit):
  ((7 * $limit) | primeSieve | map(select(.))) as $primes
  | { under250: [0, 1],
      sisyphus: [1],
      prev: 1,
      nextPrimeIndex: 0,
      specific: 1000,
      count:1 }
  | while(.count <= $limit;
      .emit = null
      | if .prev % 2 == 0 then .next = .prev/2
        else .next = .prev + $primes[.nextPrimeIndex]
        | .nextPrimeIndex += 1
	end
     | .count += 1
     | if .count <= 100 then .sisyphus += [.next] else . end
     | if .next < 250 then .under250[.next] += 1 else . end
     | if .count == 100
       then .emit = "The first 100 members of the Sisyphus sequence are:\n" + (.sisyphus | tprint(10;3))
       elif .count == .specific
       then $primes[.nextPrimeIndex-1] as $prime
       | .emit = "\(.count|lpad(8))th member is: \(.next|lpad(10)) and highest prime needed: \($prime|lpad(10))"
         | .specific *= 10
       else .
       end
    | .prev = .next )
  # The results:
  | select(.emit).emit,
    if .count == $limit
    then .under250 as $u
    | [range(1;250) | select( $u[.] == null)] as $notFound
    | ($u|max) as $max
    | [range(1;250) | select($u[.] == $max)] as $maxFound
    | "\nThese numbers under 250 do not occur in the first \(.count) terms:",
      "  \($notFound)",
      "\nThese numbers under 250 occur the most in the first \(.count) terms:",
      "  \($maxFound) all occur \($max) times."
    else empty
    end;

task(1e7)
