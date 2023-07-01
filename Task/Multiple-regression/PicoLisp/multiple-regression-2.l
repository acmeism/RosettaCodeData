(de matInverse (Mat)
   (let N (length Mat)
      (unless (= N (length (car Mat)))
         (quit "can't invert a non-square matrix") )
      (mapc conc Mat (matIdent N))
      (mapcar '((L) (tail N L)) (reducedRowEchelonForm Mat)) ) )

(de columnVector (Ary)
   (mapcar cons Ary) )

(de regressionCoefficients (Mat X)
   (let Xt (matTrans X)
      (matMul (matMul (matInverse (matMul Xt X)) Xt) Mat) ) )

(setq
   Y (columnVector (1.0 2.0 3.0 4.0 5.0))
   X (columnVector (2.0 1.0 3.0 4.0 5.0)) )

(round (caar (regressionCoefficients Y X)) 17)
