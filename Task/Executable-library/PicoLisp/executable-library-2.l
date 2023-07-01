#!/usr/bin/picolisp /usr/lib/picolisp/lib.l

(load "hailstone.l")

(let Len NIL
   (for N 100000
      (accu 'Len (length (hailstone N)) 1) )
   (let M (maxi cdr Len)
      (prinl "The hailstone length returned most often is " (car M))
      (prinl "It is returned " (cdr M) " times") ) )
(bye)
