\ -*- mode: forth -*-
\
\ The following was written for Gforth, using its implementation of
\ local variables and of f=
\

Defer f

: simpson-rule { F: a F: fa F: b F: fb -- m fm quadval }
    a b f+ 0.5e0 f*                     \ -- m
    fdup f                              \ -- m fm
    fdup 4.0e0 f* fa f+ fb f+
    b a f- 6.0e0 f/ f*                  \ -- m fm quadval
;

: recursive-simpson
    { F: a F: fa F: b F: fb F: tol F: whole F: m F: fm depth -- quadval }
    a fa m fm simpson-rule { F: lm F: flm F: left }
    m fm b fb simpson-rule { F: rm F: frm F: right }
    left right f+ whole f- { F: delta }
    tol 0.5e0 f*           { F: tol_ }
    depth 0 <=
    tol_ tol f= or
    delta fabs 15.0e0 tol f* f<= or
    if
        left right f+ delta 15.0e0 f/ f+
    else
        a fa m fm tol_ left lm flm depth 1 - recurse
        m fm b fb tol_ right rm frm depth 1 - recurse
        f+
    then
;

: quad-asr { F: a F: b F: tol depth -- quadval }
    a f { F: fa }
    b f { F: fb }
    a fa b fb simpson-rule { F: m F: fm F: whole }
    a fa b fb tol whole m fm depth recursive-simpson
;

:noname fsin ; IS f

." estimate of ∫ sin x dx from 0 to 1: "
0.0e0 1.0e0 1.0e-12 100 quad-asr f.
cr
