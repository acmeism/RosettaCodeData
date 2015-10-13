fun
	ntol (0, x) = if len x < 1 then [0] else x
       | (n, x) = ntol (n div 10, (n mod 10) :: x)
       | n      = ntol (n, [])
and
	powers_of_10 9 = 1000000000
               | 8 = 100000000
               | 7 = 10000000
               | 6 = 1000000
               | 5 = 100000
               | 4 = 10000
               | 3 = 1000
               | 2 = 100
               | 1 = 10
               | 0 = 1
and
	size (c, 0) = c
       | (c, n > 9999999999) = size (c + 10, trunc (n / 10000000000))
       | (c, n)              = size (c +  1, trunc (n / 10))
       | n                   = size (     0, trunc (n / 10))
and
	makeVisible L = map (fn x = if int x then chr (x + 48) else x) L
and
	log10 (n, 0, x) = ston ` implode ` makeVisible ` rev x
        | (n, c, x) =
            let val n' = n^10;
              val size_n' = size n'
            in
              log10 (n' / powers_of_10 size_n', c - 1, size_n' :: x)
			end
        | (n, c) =
            let
              val size_n = size n
            in
              log10 (n / 10^size_n, c, #"." :: rev (ntol size_n) @ [])
            end
;
val fourThreeTwo = 4^3^2;
val fiveFourThreeTwo = 5^fourThreeTwo;

val digitCount = trunc (log10(5,6) * fourThreeTwo + 0.5);
print "Count  = "; println digitCount;

val end20 = fiveFourThreeTwo mod (10^20);
print "End 20 = "; println end20;

val top20 = fiveFourThreeTwo div (10^(digitCount - 20));
print "Top 20 = "; println top20;
