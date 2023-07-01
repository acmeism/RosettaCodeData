(define BEAVER
  (Turing-Machine #:start 'a
   [a () 1 right b]
   [a  1 1 left  c]
   [b () 1 left  a]
   [b  1 1 right b]
   [c () 1 left  b]
   [c  1 1 stay  halt]))
