(scl 2)

(de *Items
   ("beef" 3.8 36.0)
   ("pork" 5.4 43.0)
   ("ham" 3.6 90.0)
   ("greaves" 2.4 45.0)
   ("flitch" 4.0 30.0)
   ("brawn" 2.5 56.0)
   ("welt" 3.7 67.0)
   ("salami" 3.0 95.0)
   ("sausage" 5.9 98.0) )

(let K
   (make
      (let Weight 0
         (for I (by '((L) (*/ (caddr L) -1.0 (cadr L))) sort *Items)
            (T (= Weight 15.0))
            (inc 'Weight (cadr I))
            (T (> Weight 15.0)
               (let W (- (cadr I) Weight -15.0)
                  (link (list (car I) W (*/ W (caddr I) (cadr I)))) ) )
            (link I) ) ) )
   (for I K
      (tab (3 -9 8 8)
         NIL
         (car I)
         (format (cadr I) *Scl)
         (format (caddr I) *Scl) ) )
   (tab (12 8 8)
      NIL
      (format (sum cadr K) *Scl)
      (format (sum caddr K) *Scl) ) )
