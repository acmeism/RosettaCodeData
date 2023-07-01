# Emit a stream beginning with 1 and followed by the integers that are
# cube-roots of their proper divisors
def numbers_being_cube_roots_of_their_proper_divisors:
  range(1; infinite)
    | select(prod(proper_divisors) == .*.*.);

# print first 50 and then the 500th, 5000th, and $limit-th
def harness(generator; $limit):
  label $out
  | foreach generator as $n (
      { numbers50: [],
        count: 0 };
      .emit = null
      | .count += 1
      | if .count > $limit
        then break $out
        else if .count <= 50
             then .numbers50 += [$n]
             else .
             end
        | if .count == 50
          then .emit = .numbers50
          elif .count | IN(500, 5000, $limit)
          then .emit = "\(.count)th: \($n)"
          else .
          end
        end )
  | .emit // empty ;

"First 50 numbers which are the cube roots of the products of their proper divisors:",
harness(numbers_being_cube_roots_of_their_proper_divisors; 50000)
