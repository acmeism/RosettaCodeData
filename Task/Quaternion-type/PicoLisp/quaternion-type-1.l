(scl 6)

(def 'quatCopy copy)

(de quatNorm (Q)
   (sqrt (sum * Q Q)) )

(de quatNeg (Q)
   (mapcar - Q) )

(de quatConj (Q)
   (cons (car Q) (mapcar - (cdr Q))) )

(de quatAddR (Q R)
   (cons (+ R (car Q)) (cdr Q)) )

(de quatAdd (Q1 Q2)
   (mapcar + Q1 Q2) )

(de quatMulR (Q R)
   (mapcar */ (mapcar * Q (circ R)) (1.0 .)) )

(de quatMul (Q1 Q2)
   (mapcar
      '((Ops I)
         (sum '((Op R I) (Op (*/ R (get Q2 I) 1.0))) Ops Q1 I) )
      '((+ - - -) (+ + + -) (+ - + +) (+ + - +))
      '((1 2 3 4) (2 1 4 3) (3 4 1 2) (4 3 2 1)) ) )

(de quatFmt (Q)
   (mapcar '((R S) (pack (format R *Scl) S))
      Q
      '(" + " "i + " "j + " "k") ) )
