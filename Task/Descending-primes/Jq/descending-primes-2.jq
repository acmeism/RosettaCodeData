[range(9;0;-1)]
| [powersets
   | map(tostring)
   | join("")
   | select(length > 0)
   | tonumber
   | select(is_prime)]
| sort
| _nwise(10)
| map(lpad(9))
| join(" ")
