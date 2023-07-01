(mac myswap (a b)
     (w/uniq gx
             `(let ,gx a
                   (= a b)
                   (= b ,gx))))

(with (a 1
       b 2)
      (myswap a b)
      (prn "a:" a #\Newline "b:" b))
