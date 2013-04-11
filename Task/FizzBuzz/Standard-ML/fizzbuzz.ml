fun output x =
  case (x mod 3 = 0, x mod 5 = 0) of
    (true , true ) => "FizzBuzz"
  | (true , false) => "Fizz"
  | (false, true ) => "Buzz"
  | (false, false) => Int.toString x

val () = let
  fun aux i = if i <= 100 then (print (output i ^ "\n");
                            aux (i+1))
                      else ()
in
  aux 1
end
