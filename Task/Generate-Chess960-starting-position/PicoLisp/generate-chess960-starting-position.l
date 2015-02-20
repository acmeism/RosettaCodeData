(load "@lib/simul.l")

(seed (in "/dev/urandom" (rd 8)))

(loop
   (match
      '(@A B @B B @C)
      (shuffle '(Q B B N N 0 0 0)) )
   (NIL (bit? 1 (length @B))) )

(let Rkr '(R K R)
   (for I (append @A '(B) @B '(B) @C)
      (prin (if (=0 I) (pop 'Rkr) I)) )
   (prinl) )

(bye)
