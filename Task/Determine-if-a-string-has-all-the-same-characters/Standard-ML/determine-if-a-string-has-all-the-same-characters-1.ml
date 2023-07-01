datatype result=allSame | difference of string*char*int ;
val chkstring =  fn input =>
let
val rec chk =  fn ([],n)     => allSame
               |  ([x],n)    => allSame
	       |  (x::y::t,n)=> if x=y then chk (y::t,n+1)
	                                else difference (Int.fmt StringCvt.HEX(Char.ord(y)),y,n)
in
(  input,  String.size input ,   chk ( String.explode  input,2 )  )
end;
