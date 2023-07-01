(let Expression '(+ X (* X X))            # Local expression
   (println
      (+
         (let X 3
            (eval Expression) )
         (let X 4
            (eval Expression) ) ) )
   (let Function (list '(X) Expression)   # Build a local function
      (println
         (+
            (Function 3)
            (Function 4) ) ) ) )
