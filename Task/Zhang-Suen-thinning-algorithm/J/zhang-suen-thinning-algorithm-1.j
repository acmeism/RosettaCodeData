isBlackPx=: '1'&=;._2             NB. boolean array of black pixels
toImage=: [: , LF ,.~ '01' {~ ]   NB. convert to original representation
frameImg=: 0 ,. 0 , >:@$ {. ]     NB. adds border of 0's to image

neighbrs=: adverb define          NB. applies verb u to neighbourhoods
  (1 1 ,: 3 3) u;._3 y
)

Bdry=: 1 2 5 8 7 6 3 0 1          NB. map pixel index to neighbour order
getPx=: { ,                       NB. get desired pixels from neighbourhood
Ap1=: [: +/ 2 </\ Bdry&getPx      NB. count 0->1 transitions
Bp1=: [: +/ [: }. Bdry&getPx      NB. count black neighbours

c11=: (2&<: *. <:&6)@Bp1          NB. step 1, condition 1
c12=: 1 = Ap1                     NB. ...
c13=: 0 e. 1 5 7&getPx
c14=: 0 e. 5 7 3&getPx
c23=: 0 e. 1 5 3&getPx            NB. step2, condition 3
c24=: 0 e. 1 7 3&getPx

cond1=: c11 *. c12 *. c13 *. c14  NB. step1 conditions
cond2=: c11 *. c12 *. c23 *. c24  NB. step2 conditions
whiten=: [ * -.@:*.               NB. make black pixels white
step1=: whiten frameImg@(cond1 neighbrs)
step2=: whiten frameImg@(cond2 neighbrs)

zhangSuen=: [: toImage [: step2@step1^:_ isBlackPx
