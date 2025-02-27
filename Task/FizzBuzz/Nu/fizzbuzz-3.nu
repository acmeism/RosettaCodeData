1..100 | each {(
  if $in mod 15 == 0 {'FizzBuzz'}
  else if $in mod 3 == 0 {'Fizz'}
  else if $in mod 5 == 0 {'Buzz'}
  else {$in}
)} | str join "\n"
