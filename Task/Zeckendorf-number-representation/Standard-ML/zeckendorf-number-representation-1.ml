val zeckList = fn from => fn to =>

 let
  open IntInf

 val rec npow = fn n => fn 0 => fromInt 1 | m => n* (npow n (m-1)) ;

 val fib = fn 0 => 1 | 1 => 1 | n => let   val rec fb = fn x => fn y => fn 1=>y | n=> fb y (x+y) (n-1)  in
        fb 0 1  n
     end;

 val argminfi =  fn n =>                                          (* lowest k with fibonacci number over n *)
   let
      val rec afb = fn k => if fib k > n then k else afb (k+1)
   in
      afb 0
   end;

 val Zeck = fn n =>
   let
      val rec calzk = fn (0,z) => (0,z)
                       | (n,z) => let  val k =  argminfi n  in
                                     calzk ( n - fib (k-1) , z + (npow 10 (k-3) ) )
				  end
   in
      #2 (calzk (n,0))
  end

 in
     List.tabulate (toInt ( to - from) ,
                    fn i:Int.int => ( from + (fromInt i),
	            Zeck ( from + (fromInt i) )))
end;
