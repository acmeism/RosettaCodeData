"(* Leading, trailing, and multiple white spaces ignored *)
ignore superfluous spaces: 1-1
  ignore superfluous    spaces: 1-2
  ignore superfluous spaces: 1-3
   ignore superfluous spaces: 1-4
ignore superfluous    spaces: 1-5
ignore superfluous   spaces: 1-6
ignore superfluous spaces: 1-7
   ignore    superfluous     spaces: 1-8

(* All white space characters treated as equivalent *)
Equiv.	spaces: 2-1
Equiv.
spaces: 2-2
Equiv.�spaces: 2-3
Equiv.�spaces: 2-4
Equiv.
spaces: 2-5
Equiv. spaces: 2-6

(* Case ignored. (The sort order would actually be the same with case considered,
   since case only decides the issue when strings are otherwise identical.) *)
cASE INDEPENDENT: 3-1
caSE INDEPENDENT: 3-2
CASE independent: 3-3
casE INDEPENDENT: 3-4
case INDEPENDENT: 3-5

(* Numerics considered by number value *)
foo100bar10baz0.txt
foo100bar99baz0.txt
foo1000bar99baz9.txt
foo1000bar99baz10.txt

(* Title sort *)
The 39 steps
The 40th Step More
An Inspector Calls
A Matter of Life and Death
Wanda
The Wind in the Willows

(* Diacriticals (and case) ignored *)
Equiv. ý accents: 6-1
Equiv. Y accents: 6-2
Equiv. Ý accents: 6-3
Equiv. y accents: 6-4

(* Ligatures *)
Ĳ ligatured
ij no ligature
od
œ
of

(* Custom \"s\" equivalents and Esszet (NB. Esszet normalises to \"ss\") *)
Start with an ʒ: 8-1
Start with an ſ: 8-2
Start with an s: 8-4
Start with an ß: 8-3
Start with an ss: 8-5"
