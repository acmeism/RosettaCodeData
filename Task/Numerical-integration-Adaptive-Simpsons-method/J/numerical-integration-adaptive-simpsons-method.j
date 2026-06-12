Note'expected answer computed by j www.jsoftware.com'

       1-&:(1&o.d._1)0
    0.459698

    translated from c
)

mp=: +/ .*  NB. matrix product

NB. Evaluates Simpson's Rule, also returning m and f(m) to reuse.
uquad_simpsons_mem=: adverb define
 'a fa b fb'=. y
 em=. a ([ + [: -: -~) b
 fm=. u em
 simp=. ((| b - a) % 6) * 1 4 1 mp fa , fm , fb
 em, fm, simp
)

Simp=: 1 :'2{m'
Fm=: 1 :'1{m'
M=: 1 :'0{m'

NB. Efficient recursive implementation of adaptive Simpson's rule.	
NB. Function values at the start, middle, end of the intervals are retained.
uquad_asr=: adverb define
 'a fa b fb eps whole em fm'=. y
 lt=. u uquad_simpsons_mem(a, fa, em, fm)
 rt=. u uquad_simpsons_mem(em, fm, b, fb)
 delta=. lt Simp + rt Simp - whole
 if. (| delta) <: eps * 15 do.
  lt Simp + rt Simp + delta % 15
 else.
  (a, fa, em, fm, (-: eps), lt Simp, lt M, lt Fm) +&(u uquad_asr) (em, fm, b, fb, (-: eps), rt Simp, rt M, rt Fm)
 end.
)

NB. Integrate u from a to b using ASR with max error of eps.
quad_asr=: adverb define
 'a b eps'=. y
 fa=. u a
 fb=. u b
 t=. u uquad_simpsons_mem a, fa, b, fb
 u uquad_asr a, fa, b, fb, eps, t Simp, t M, t Fm
)
