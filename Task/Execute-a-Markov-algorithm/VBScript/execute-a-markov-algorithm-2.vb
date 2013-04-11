dim m1
set m1 = new markovparser
m1.ruleset = "# This rules file is extracted from Wikipedia:" & vbNewLine & _
"# http://en.wikipedia.org/wiki/Markov_Algorithm" & vbNewLine & _
"A -> apple" & vbNewLine & _
"B -> bag" & vbNewLine & _
"S -> shop" & vbNewLine & _
"T -> the" & vbNewLine & _
"the shop -> my brother" & vbNewLine & _
"a never used -> .terminating rule"
wscript.echo m1.apply( "I bought a B of As from T S.")

dim m2
set m2 = new markovparser
m2.ruleset = replace( "# Slightly modified from the rules on Wikipedia\nA -> apple\nB -> bag\nS -> .shop\nT -> the\nthe shop -> my brother\na never used -> .terminating rule", "\n", vbNewLine )
'~ m1.dump
wscript.echo m2.apply( "I bought a B of As from T S.")

dim m3
set m3 = new markovparser
m3.ruleset = replace("# BNF Syntax testing rules\nA -> apple\nWWWW -> with\nBgage -> ->.*\nB -> bag" & vbNewLine & _
"->.* -> money\nW -> WW\nS -> .shop\nT -> the\nthe shop -> my brother\na never used -> .terminating rule", "\n", vbNewLine )
wscript.echo m3.apply("I bought a B of As W my Bgage from T S.")

set m4 = new markovparser
m4.ruleset = "### Unary Multiplication Engine, for testing Markov Algorithm implementations" & vbNewLine & _
"### By Donal Fellows." & vbNewLine & _
"# Unary addition engine" & vbNewLine & _
"_+1 -> _1+" & vbNewLine & _
"1+1 -> 11+" & vbNewLine & _
"# Pass for converting from the splitting of multiplication into ordinary" & vbNewLine & _
"# addition" & vbNewLine & _
"1! -> !1" & vbNewLine & _
",! -> !+" & vbNewLine & _
"_! -> _" & vbNewLine & _
"# Unary multiplication by duplicating left side, right side times" & vbNewLine & _
"1*1 -> x,@y" & vbNewLine & _
"1x -> xX" & vbNewLine & _
"X, -> 1,1" & vbNewLine & _
"X1 -> 1X" & vbNewLine & _
"_x -> _X" & vbNewLine & _
",x -> ,X" & vbNewLine & _
"y1 -> 1y" & vbNewLine & _
"y_ -> _" & vbNewLine & _
"# Next phase of applying" & vbNewLine & _
"1@1 -> x,@y" & vbNewLine & _
"1@_ -> @_" & vbNewLine & _
",@_ -> !_" & vbNewLine & _
"++ -> +" & vbNewLine & _
"# Termination cleanup for addition" & vbNewLine & _
"_1 -> 1" & vbNewLine & _
"1+_ -> 1" & vbNewLine & _
"_+_ -> "
'~ m4.dump
wscript.echo m4.apply( "_1111*11111_")

set fso = createobject("scripting.filesystemobject")
set m5 = new markovparser
m5.ruleset = fso.opentextfile("busybeaver.tur").readall
wscript.echo m5.apply("000000A000000")
