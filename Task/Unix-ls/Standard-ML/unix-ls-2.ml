local   (* make a sort function *)
  val rec insert = fn s :string =>fn [] => [s]
	| ll as h::t => if s<=h then s::ll else h::insert s t;
in
  val rec sort = fn [] => [] | h::t => insert h (sort t)
end;

open Posix.FileSys ;
val istream = opendir "." ;
val ll =  ref [readdir istream] ;
while ( isSome (hd (!ll)) ) do  ( ll:=readdir istream :: !ll );
val result = List.map valOf (tl (!ll));
closedir istream ;

sort result;
