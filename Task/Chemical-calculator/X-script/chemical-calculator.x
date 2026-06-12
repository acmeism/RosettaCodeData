<var $weighttab[],
-H:1.008|He:4.002602|Li:6.94|Be:9.0121831|B:10.81|C:12.011|N:14.007|O:15.999|F:18.998403163|
-Ne:20.1797|Na:22.98976928|Mg:24.305|Al:26.9815385|Si:28.085|P:30.973761998|S:32.06|Cl:35.45|
-K:39.0983|Ar:39.948|Ca:40.078|Sc:44.955908|Ti:47.867|V:50.9415|Cr:51.9961|Mn:54.938044|
-Fe:55.845|Ni:58.6934|Co:58.933194|Cu:63.546|Zn:65.38|Ga:69.723|Ge:72.63|As:74.921595|Se:78.971|
-Br:79.904|Kr:83.798|Rb:85.4678|Sr:87.62|Y:88.90584|Zr:91.224|Nb:92.90637|Mo:95.95|Ru:101.07|
-Rh:102.9055|Pd:106.42|Ag:107.8682|Cd:112.414|In:114.818|Sn:118.71|Sb:121.76|I:126.90447|Te:127.6|
-Xe:131.293|Cs:132.90545196|Ba:137.327|La:138.90547|Ce:140.116|Pr:140.90766|Nd:144.242|Pm:145|
-Sm:150.36|Eu:151.964|Gd:157.25|Tb:158.92535|Dy:162.5|Ho:164.93033|Er:167.259|Tm:168.93422|
-Yb:173.054|Lu:174.9668|Hf:178.49|Ta:180.94788|W:183.84|Re:186.207|Os:190.23|Ir:192.217|Pt:195.084|
-Au:196.966569|Hg:200.592|Tl:204.38|Pb:207.2|Bi:208.9804|Po:209|At:210|Rn:222|Fr:223|Ra:226|Ac:227|
-Pa:231.03588|Th:232.0377|Np:237|U:238.02891|Am:243|Pu:244|Cm:247|Bk:247|Cf:251|Es:252|Fm:257|
-Ubn:299|Uue:315
->
<var $level>
<var $stackTab[]>

chemicalCalculator.x
--------------------

<def charcode,<htod <stoh $1>>>
<var $name>
<var $multiplier>
<var $unusedCharacters>

!"<in <sp 1>,string>
-<set $level,0>
-<set $stackTab[0],0>
-"!

(* 1-3 characters in a row plus optional multipier. Examples: "Uee", "NaO", "COO", "Na2"  *)
?"<format l><opt <format l>><opt <format l>><opt <integer>>"?
!"
-<set $name,<p 1>>
-<set $multiplier,1>
-<set $unusedCharacters,>
-<ifis <p 2>,
--<if <charcode <p 2>>'>=96,
---(* Lower case char - add to name. *)
---<append $name,<p 2>>
---<ifis <p 3>,
----<if <charcode <p 3>>'>=96,
-----(* Lower case char again - add to name. *)
-----<append $name,<p 3>>
-----,{else}
-----(* Not for this name, put in unread buffer. *)
-----<append $unusedCharacters,<p 3>>
----->
---->
---,{else}
---(* Not for this name, put in unread buffer. *)
---<append $unusedCharacters,<p 2>>
---<append $unusedCharacters,<p 3>>
--->
-->
-(* Multiplier. *)
-<set $multiplier,1>
-<ifis <p 4>,
--<ifis $unusedCharacters,
---(* Multiplier is not for this name, put in unread buffer. *)
---<append $unusedCharacters,<p 4>>
---,{else}
---(* Use as multiplier. *)
---<set $multiplier,<p 4>>
--->
-->
-
-(* Unread unused characters. *)
-<unread $unusedCharacters>
-
-(* Update weight. *)
-<update $stackTab[$level],+$weightTab[$name]*$multiplier,3>
-"!

(* Beginning of group. *)
?"("?
!"
-<update $level,+1>
-<set $stackTab[$level],0>
-"!

(* End of group. *)
?")<opt <integer>>"?
!"
-<ifis <p 1>,
--<update $stackTab[$level],*<p 1>,3>
-->
-<update $stackTab[<calc $level-1>],+$stackTab[$level],3>
-<update $level,-1>
-"!

?"<eof>"?
!"
-<wcons Weight of <sp 1> = $stackTab[$level].>
-<r>
-"!

!"<r $stackTab[$level]>"!
--------------

<function assert,
-<unless $1=<c chemicalCalculator,$2>,<wcons <c chemicalCalculator,$2>!= $1.>>
->

<assert    1.008,H>
<assert    2.016,H2>
<assert   18.015,H2O>
<assert   34.014,H2O2>
<assert   34.014,(HO)2>
<assert  142.036,Na2SO4>
<assert   84.162,C6H12>
<assert  186.295,COOH(C(CH3)2)3CH3>
<assert  176.124,C6H4O2(OH)4>
<assert  386.664,C27H46O>
<assert  315    ,Uue>
