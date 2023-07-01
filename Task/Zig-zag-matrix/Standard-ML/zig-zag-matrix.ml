fun rowprint r = (List.app (fn i => print (StringCvt.padLeft #" " 3 (Int.toString i))) r;
                  print "\n");
fun zig lst M  =  List.app rowprint (lst M);

fun sign t = if t mod 2 = 0 then ~1 else 1;

fun zag n = List.tabulate (n,
            fn i=> rev ( List.tabulate (n,
                        fn j =>
			     let val t = n-j+i  and  u =  n+j-i  in
			         if i <= j
                                    then   t*t div 2 + sign t * ( t div 2 - i )
                                    else   n*n - 1 - ( u*u div 2 + sign u * ( u div 2 - n + 1 + i) )
	                      end
			 )));

zig zag 5 ;
