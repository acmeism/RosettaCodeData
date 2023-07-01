# Output: the Euclid-Mullins sequence, beginning with 2
def euclid_mullins:
  foreach range(1; infinite|floor) as $i ( { product: 1 };
        .next = .product + 1
        # find the first prime factor of .next
        | .p = 3
        | .found = false
        | until( .p * .p > .next or .found;
            .found = ((.next % .p) == 0)
            | if .found then . else .p += 2 end)
        | if .found then .next = .p else . end
        | .product *= .next)
  | .next ;

# Produce 16 terms
limit(16; euclid_mullins)
