[UNDEFINED] ANS [IF]
include lib/fp1.4th                    \ Zen float version
include lib/zenfprox.4th               \ for F~
include lib/zenround.4th               \ for FROUND
include lib/zenfln.4th                 \ for FLN
include lib/zenfpow.4th                \ for FPOW
[ELSE]
include lib/fp3.4th                    \ ANS float version
include lib/flnflog.4th                \ for FLN
include lib/fpow.4th                   \ for FPOW
[THEN]

include lib/fast-fac.4th               \ for FACTORIAL

fclear                                 \ initialize floating point
float array ln2 2 s>f fln latest f!    \ precalculate ln(2)
                                       \ integer exponentiation
: hickerson dup >r factorial s>f ln2 f@ r> 1+ fpow fdup f+ f/ ;
: integer? if ." TRUE " else ." FALSE" then space ;
                                       \ is it an integer?
: first17
  18 1 do                              \ test hickerson 1-17
    i hickerson i 2 .r space fdup fdup fround
    s" 1e-1" s>float f~ integer? f. cr
  loop                                 \ within 0.1 absolute error
;

first17
