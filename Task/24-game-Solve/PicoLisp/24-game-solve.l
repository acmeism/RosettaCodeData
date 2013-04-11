(be play24 (@Lst @Expr)                # Define Pilog rule
   (permute @Lst (@A @B @C @D))
   (member @Op1 (+ - * /))
   (member @Op2 (+ - * /))
   (member @Op3 (+ - * /))
   (or
      ((equal @Expr (@Op1 (@Op2 @A @B) (@Op3 @C @D))))
      ((equal @Expr (@Op1 @A (@Op2 @B (@Op3 @C @D))))) )
   (@ = 24 (catch '("Div/0") (eval (-> @Expr)))) )

(de play24 (A B C D)                   # Define PicoLisp function
   (pilog
      (quote
         @L (list A B C D)
         (play24 @L @X) )
      (println @X) ) )

(play24 5 6 7 8)                       # Call 'play24' function
