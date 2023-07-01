val segmentedSieve =  fn N =>
(* output : list of {segment=bit segment, start=number at startposition segment} *)

let

val NSegmt= 120000000;                                                                                  (* segment size *)


val inf2i = IntInf.toInt ;
val i2inf = IntInf.fromInt ;
val isInt = fn m => m <= IntInf.fromInt (valOf Int.maxInt);

val sweep = fn (bits, step, k, up) =>                                                                   (* strike off bits up to limit *)
       (while (  !k < up  andalso 0 <= !k  ) do
             (  BitArray.clrBit( bits, !k ) ; k:= !k +  step ; ()) ) handle Overflow => ()

val rec nextPrimebit =                                                                                  (* find next 1-bit within segment *)
     fn Bits =>
     fn pos  =>
        if pos+1 >= BitArray.length Bits
	  then    NONE
          else    ( if BitArray.sub ( Bits,pos) then SOME (i2inf pos) else nextPrimebit Bits (pos+1) );


val sieveEratosthenes =  fn n: int =>                                                             (* Eratosthenes sieve , up to+incl n *)

 let
  val nums= BitArray.bits(n,[] );
  val i=ref 2;
  val k=ref (!i * (!i) -1);

 in

  ( BitArray.complement nums;
    BitArray.clrBit( nums, 0 );
    while ( !k <n ) do (  if ( BitArray.sub (nums, !i - 1) ) then  sweep (nums, !i, k, n) else ();
      i:= !i+1;
      k:= !i * (!i) - 1
    );
    [ { start= i2inf 1, segment=nums } ]
  )

 end;



val sieveThroughSegment =

 fn ( primes : { segment:BitArray.array, start:IntInf.int } list, low : IntInf.int, up ) =>
                                                                                                        (* second segment and on *)
 let
  val n      = inf2i (up-low+1)
  val nums   = BitArray.bits(n,[] );
  val itdone = low div i2inf NSegmt

  val rec oldprimes = fn c =>  fn                                                                 (* use segment B to sweep current one *)
                 []                       => ()
      | ctlist as {start=st,segment=B}::t =>
       let

        val nxt  = nextPrimebit B c ;
        val p    = st +  Option.getOpt( nxt,~10)
        val modp = ( i2inf NSegmt * itdone ) mod p
        val i    = inf2i ( if( isInt( p - modp ) ) then p - modp else 0 )                               (* i = 0 breaks off *)
        val k    = ref   ( if Option.isSome nxt  then  (i - 1)  else ~2 )
        val step = if (isInt(p)) then inf2i(p) else valOf Int.maxInt                                    (* !k+maxInt > n *)

       in

          ( sweep (nums, step, k, n) ;
	    if ( p*p <= up  andalso  Option.isSome nxt )
	       then    oldprimes ( inf2i (p-st+1) ) ctlist
	       else    oldprimes 0 t                                                                    (* next segment B *)
          )

       end

 in
  (  BitArray.complement nums;
     oldprimes 0 primes;
     rev ( {start = low, segment = nums } :: rev (primes) )
  )
 end;



val rec workSegmentsDown = fn firstFn =>
    			   fn nextFns =>
			   fn sizeSeg : int =>
			   fn upLimit : IntInf.int =>
 let
   val residual = upLimit mod i2inf sizeSeg
 in

   if ( upLimit <= i2inf sizeSeg ) then firstFn (  inf2i upLimit )
   else
     if ( residual > 0 ) then
           nextFns ( workSegmentsDown firstFn nextFns sizeSeg (upLimit - residual ),     upLimit - residual      + 1, upLimit )
     else
           nextFns ( workSegmentsDown firstFn nextFns sizeSeg (upLimit - i2inf sizeSeg), upLimit - i2inf sizeSeg + 1, upLimit )
 end;

in

  workSegmentsDown  sieveEratosthenes  sieveThroughSegment  NSegmt  N

end;
