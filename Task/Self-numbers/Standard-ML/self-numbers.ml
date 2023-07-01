open List;

val rec selfNumberNr = fn NR =>
let
  val rec sumdgt = fn 0 => 0 | n => Int.rem (n, 10) + sumdgt (Int.quot(n ,10));
  val rec isSelf  = fn ([],l1,l2) => []
   | (x::tt,l1,l2) => if exists (fn i=>i=x) l1 orelse exists (fn i=>i=x) l2
			  then ( isSelf (tt,l1,l2)) else x::isSelf (tt,l1,l2) ;

  val rec partcount =  fn  (n, listIn , count , selfs) =>
         if count >= NR then  nth (selfs, length selfs + NR - count -1)
           else
         let
          val range   = tabulate (81 , fn i => 81*n +i+1) ;
          val listOut = map (fn i => i + sumdgt i ) range ;
          val selfs   = isSelf (range,listIn,listOut)
         in
          partcount ( n+1 , listOut , count+length (selfs) , selfs )
       end;
in
  partcount (0,[],0,[])
end;

app  ((fn s => print (s ^ " ")) o Int.toString o selfNumberNr)  (tabulate (50,fn i=>i+1)) ;
selfNumberNr 100000000 ;
