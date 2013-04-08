bottlesOfBeer = (n) ->
  "#{n} bottle#{if n is 1 then '' else 's'} of beer"

console.log """
  #{bottlesOfBeer n} on the wall
  #{bottlesOfBeer n}
  Take one down, pass it around
  #{bottlesOfBeer n - 1} on the wall
  \n""" for n in [99..1]
