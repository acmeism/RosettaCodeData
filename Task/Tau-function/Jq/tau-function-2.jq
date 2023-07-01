[range(1;101) | count(divisors)]
| nwise(10) | map(lpad(4)) | join("")
