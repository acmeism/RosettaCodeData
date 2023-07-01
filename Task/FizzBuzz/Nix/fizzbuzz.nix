with (import <nixpkgs> { }).lib;
with builtins;
let
  fizzbuzz = { x ? 1 }:
    ''
      ${if (mod x 15 == 0) then
        "FizzBuzz"
      else if (mod x 3 == 0) then
        "Fizz"
      else if (mod x 5 == 0) then
        "Buzz"
      else
        (toString x)}
    '' + (if (x < 100) then
      fizzbuzz { x = x + 1; } else "");
in
fizzbuzz { }
