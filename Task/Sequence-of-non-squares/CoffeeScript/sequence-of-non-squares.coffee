non_square = (n) -> n + Math.floor(1/2 + Math.sqrt(n))

is_square = (n) ->
  r = Math.floor(Math.sqrt(n))
  r * r is n

do ->
  first_22_non_squares = (non_square i for i in [1..22])
  console.log first_22_non_squares

  # test is_square has no false negatives:
  for i in [1..10000]
    throw Error("is_square broken") unless is_square i*i

  # test non_square is valid for first million values of n
  for i in [1..1000000]
    throw Error("non_square broken") if is_square non_square(i)

  console.log "success"
