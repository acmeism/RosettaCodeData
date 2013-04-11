(de nacci (Init Cnt)
   (let N (length Init)
      (make
         (made Init)
         (do (- Cnt N)
            (link (apply + (tail N (made)))) ) ) ) )
