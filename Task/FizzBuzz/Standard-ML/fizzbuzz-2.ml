local
  fun fb i = let val fizz = i mod 3 = 0 andalso (print "Fizz"; true)
                 val buzz = i mod 5 = 0 andalso (print "Buzz"; true)
             in fizz orelse buzz orelse (print (Int.toString i); true) end
in
  fun fizzbuzz n = (List.tabulate (n, fn i => (fb (i+1); print "\n")); ())
  val _ = fizzbuzz 100
end
