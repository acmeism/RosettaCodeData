(defun bottles-of-beer (n)
   (if (zp n)
       nil
       (prog2$ (cw (concatenate 'string
                   "~%"
                   "~N0 bottle~#1~[~/s~] of beer on the wall,~%"
                   "~n0 bottle~#1~[~/s~] of beer.~%"
                   "Take one down, pass it around,~%"
                   "~n2 bottle~#3~[~/s~] of beer on the wall.~%")
                   n
                   (if (= n 1) 0 1)
                   (1- n)
                   (if (= n 2) 0 1))
               (bottles-of-beer (- n 1)))))
