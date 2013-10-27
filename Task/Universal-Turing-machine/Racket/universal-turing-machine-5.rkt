(define SORT
  (Turing-Machine #:start 'A
   [A 1  1  right A]
   [A 2  3  right B]
   [A () () left  E]
   [B 1  1  right B]
   [B 2  2  right B]
   [B () () left  C]
   [C 1  2  left  D]
   [C 2  2  left  C]
   [C 3  2  left  E]
   [D 1  1  left  D]
   [D 2  2  left  D]
   [D 3  1  right A]
   [E 1  1  left  E]
   [E () () right STOP]))
