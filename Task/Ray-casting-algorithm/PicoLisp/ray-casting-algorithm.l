(scl 4)

(de intersects (Px Py Ax Ay Bx By)
   (when (> Ay By)
      (xchg 'Ax 'Bx)
      (xchg 'Ay 'By) )
   (when (or (= Py Ay) (= Py By))
      (inc 'Py) )
   (and
      (>= Py Ay)
      (>= By Py)
      (>= (max Ax Bx) Px)
      (or
         (> (min Ax Bx) Px)
         (= Ax Px)
         (and
            (<> Ax Bx)
            (>=
               (*/ (- Py Ay) 1.0 (- Px Ax))            # Blue
               (*/ (- By Ay) 1.0 (- Bx Ax)) ) ) ) ) )  # Red

(de inside (Pt Poly)
   (let Res NIL
      (for Edge Poly
         (when (apply intersects Edge (car Pt) (cdr Pt))
            (onOff Res) ) )
      Res ) )
