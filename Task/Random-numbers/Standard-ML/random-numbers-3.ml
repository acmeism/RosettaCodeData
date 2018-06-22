val urandomlist =  fn seed => fn n =>
let
	val uniformdeviate = fn seed =>
	let
	  val in31m = (Real.fromInt o Int32.toInt ) (getOpt (Int32.maxInt,0) );
	  val in31 = in31m +1.0;
	  val s1 = 41160.0;
	  val s2 = 950665216.0;
	  val v = Real.realFloor seed;
	  val val1 = v*s1;
	  val val2 = v*s2;
	  val next1 = Real.fromLargeInt (Real.toLargeInt IEEEReal.TO_NEGINF (val1/in31)) ;
	  val next2 = Real.rem(Real.realFloor(val2/in31) , in31m );
	  val valt = val1+val2 - (next1+next2)*in31m;
	  val nextt = Real.realFloor(valt/in31m);
	  val valt = valt - nextt*in31m;
	in
	  (valt/in31m,valt)
	end;
val store =  ref (0.0,0.0);
val rec u =  fn S => fn 0 => [] | n=> (store:=uniformdeviate S; (#1 (!store)):: (u (#2 (!store)) (n-1))) ;
in
	u seed n
end;

local
	open Math
in
	val bmconv = fn urand => fn vrand => 1.0+0.5*(sqrt(~2.0*ln urand)*cos (2.0*pi*vrand) )
end;

val rec makeNormals = fn once => fn u::v::[] => [once u v] |
	u::v::rm => (once u v )::(makeNormals once rm );

val anyrealseed=1009.0 ;
makeNormals bmconv (urandomlist anyrealseed 2000);
