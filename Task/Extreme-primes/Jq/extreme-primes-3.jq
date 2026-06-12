{ extremes:[2],
  sum:2,
  p:3,
  count:1 }
| while (.count <= 5000;
    .emit = null
    | .sum += .p
    | if .sum|is_prime
      then .count += 1
      | if .count <= 30
        then .extremes += [.sum]
        | if .count == 30
          then .emit = "The first 30 extreme primes are:\n"
          | .emit += ([.extremes | nwise(10) | map(lpad(7)) | join(" ") ] | join("\n"))
	  | .emit += "\n"
	  else .
	  end
	elif .count % 1000 == 0
        then .emit = "The \(.count)th extreme prime is: \(.sum) for p <= \(.p)"
	else .
	end
      else .
      end
    | .p |= nextprime
  )
  | .emit // empty
