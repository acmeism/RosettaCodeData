(* FizzBuzz in CDuce *)

let format (n : Int) : Latin1 =
    if (n mod 3 = 0) || (n mod 5 = 0) then "FizzBuzz"
    else if (n mod 5 = 0) then "Buzz"
    else if (n mod 3 = 0) then "Fizz"
    else string_of (n);;

let fizz (n : Int, size : Int) : _ =
    print (format (n) @ "\n");
    if (n = size) then
        n = 0 (* do nothing *)
    else
        fizz(n + 1, size);;

let fizbuzz (size : Int) : _ = fizz (1, size);;

let _ = fizbuzz(100);;
