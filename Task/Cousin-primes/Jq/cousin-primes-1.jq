# Output: a stream
def cousins:
  # [2,6] is not a cousin so we can start at 3
  range(3;.;2)
  | select(is_prime and (.+4 | is_prime))
  | [., .+4];

997 | cousins
