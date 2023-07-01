val BLOCKS = [(#"B",#"O"), (#"X",#"K"), (#"D",#"Q"), (#"C",#"P"), (#"N",#"A"), (#"G",#"T"),
 (#"R",#"E"), (#"T",#"G"), (#"Q",#"D"), (#"F",#"S"), (#"J",#"W"), (#"H",#"U"), (#"V",#"I"),
 (#"A",#"N"),(#"O",#"B"), (#"E",#"R"), (#"F",#"S"), (#"L",#"Y"), (#"P",#"C"), (#"Z",#"M")];
val words = ["A","BARK","BOOK","TREaT","COMMON","SQUAD","CONFUSE"];
open List;

local
 val remove = fn x => fn B => (fn (a,b) => (tl a)@b ) (partition ( fn a=> x=a) B)
in
fun cando ([]  , Done, B )  = true
 |  cando (h::t, Done, [])  = false
 |  cando (h::t, Done, B )  =
 let
  val S =  find (fn (a,b) => a=h orelse b=h) B
 in
  if isSome S then cando (t, (h,valOf S)::Done, remove (valOf S) B)
  else
  let
   val T = find ( fn(_,(a,b)) => a=h orelse b=h) Done
   val U = if isSome T then find (fn (a,b) => a = #1 (valOf T) orelse b = #1 (valOf T) ) B else NONE
  in
   if isSome T andalso isSome U
    then  cando ( t, (#1 (valOf T),(valOf U))::(h,#2 (valOf T))::(remove (valOf T) Done), remove (valOf U) B)
   else false
  end
 end
end;

map (fn st => cando(map Char.toUpper (String.explode st),[],BLOCKS)) words;

val BLOCKS = [(#"U",#"S"), (#"T",#"Z"), (#"A",#"O"), (#"Q",#"A")];
val words = ["A","UTAH","AutO"];
map (fn st => cando(map Char.toUpper (String.explode st),[],BLOCKS)) words;
