# This program tries to find some way to turn four digits into an arithmetic
# expression that adds up to 24.
#
# Example solution for 5, 7, 8, 8:
#    (((8 + 7) * 8) / 5)


solve_24_game = (digits...) ->
  # Create an array of objects for our helper functions
  arr = for digit in digits
    {
      val: digit
      expr: digit
    }
  combo4 arr...

combo4 = (a, b, c, d) ->
  arr = [a, b, c, d]
  # Reduce this to a three-node problem by combining two
  # nodes from the array.
  permutations = [
    [0, 1, 2, 3]
    [0, 2, 1, 3]
    [0, 3, 1, 2]
    [1, 2, 0, 3]
    [1, 3, 0, 2]
    [2, 3, 0, 1]
  ]
  for permutation in permutations
    [i, j, k, m] = permutation
    for combo in combos arr[i], arr[j]
      answer = combo3 combo, arr[k], arr[m]
      return answer if answer
  null

combo3 = (a, b, c) ->
  arr = [a, b, c]
  permutations = [
    [0, 1, 2]
    [0, 2, 1]
    [1, 2, 0]
  ]
  for permutation in permutations
    [i, j, k] = permutation
    for combo in combos arr[i], arr[j]
      answer = combo2 combo, arr[k]
      return answer if answer
  null

combo2 = (a, b) ->
  for combo in combos a, b
    return combo.expr if combo.val == 24
  null

combos = (a, b) ->
  [
    val: a.val + b.val
    expr: "(#{a.expr} + #{b.expr})"
  ,
    val: a.val * b.val
    expr: "(#{a.expr} * #{b.expr})"
  ,
    val: a.val - b.val
    expr: "(#{a.expr} - #{b.expr})"
  ,
    val: b.val - a.val
    expr: "(#{b.expr} - #{a.expr})"
  ,
    val: a.val / b.val
    expr: "(#{a.expr} / #{b.expr})"
  ,
    val: b.val / a.val
    expr: "(#{b.expr} / #{a.expr})"
  ,
  ]

# test
do ->
  rand_digit = -> 1 + Math.floor (9 * Math.random())

  for i in [1..15]
    a = rand_digit()
    b = rand_digit()
    c = rand_digit()
    d = rand_digit()
    solution = solve_24_game a, b, c, d
    console.log "Solution for #{[a,b,c,d]}: #{solution ? 'no solution'}"
