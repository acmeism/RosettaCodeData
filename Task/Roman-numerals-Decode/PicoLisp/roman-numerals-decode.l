(de roman2decimal (Rom)
   (let L (replace (chop Rom) 'M 1000 'D 500 'C 100 'L 50 'X 10 'V 5 'I 1)
      (sum '((A B) (if (>= A B) A (- A))) L (cdr L)) ) )
