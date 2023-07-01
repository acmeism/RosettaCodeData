(load "@lib/math.l")

(de addComplex (A B)
   (cons
      (+ (car A) (car B))        # Real
      (+ (cdr A) (cdr B)) ) )    # Imag

(de mulComplex (A B)
   (cons
      (-
         (*/ (car A) (car B) 1.0)
         (*/ (cdr A) (cdr B) 1.0) )
      (+
         (*/ (car A) (cdr B) 1.0)
         (*/ (cdr A) (car B) 1.0) ) ) )

(de invComplex (A)
   (let Denom
      (+
         (*/ (car A) (car A) 1.0)
         (*/ (cdr A) (cdr A) 1.0) )
      (cons
         (*/ (car A) 1.0 Denom)
         (- (*/ (cdr A) 1.0 Denom)) ) ) )

(de negComplex (A)
   (cons (- (car A)) (- (cdr A))) )

(de fmtComplex (A)
   (pack
      (round (car A) (dec *Scl))
      (and (gt0 (cdr A)) "+")
      (round (cdr A) (dec *Scl))
      "i" ) )

(let (A (1.0 . 1.0)  B (cons pi 1.2))
   (prinl "A = " (fmtComplex A))
   (prinl "B = " (fmtComplex B))
   (prinl "A+B = " (fmtComplex (addComplex A B)))
   (prinl "A*B = " (fmtComplex (mulComplex A B)))
   (prinl "1/A = " (fmtComplex (invComplex A)))
   (prinl "-A = " (fmtComplex (negComplex A))) )
