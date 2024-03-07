(de isbn13? (S)
   (let L
      (make
         (for N (chop S)
            (and (format N) (link @)) ) )
      (and
         (= 13 (length L))
         (=0 (% (sum * L (circ 1 3)) 10)) ) ) )
(mapc
   '((A)
      (tab
         (-19 1)
         A
         (if (isbn13? A) 'ok 'fail) ) )
   (quote
      "978-0596528126"
      "978-0596528120"
      "978-1-86197-876-9"
      "978-2-74839-908-5"
      "978 1 86197 876 9" ) )
