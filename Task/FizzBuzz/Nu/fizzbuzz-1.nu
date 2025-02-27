1..100 | each {
  { x: $in, mod3: ($in mod 3), mod5: ($in mod 5), }
  | match $in {
    { mod3: 0, mod5: 0, } => 'FizzBuz',
    { mod3: 0, mod5: _, } => 'Fizz',
    { mod3: _, mod5: 0, } => 'Buzz',
                        _ => $in.x
  }
} | str join "\n"
