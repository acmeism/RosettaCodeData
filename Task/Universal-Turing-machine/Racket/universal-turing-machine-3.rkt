(define ADD1
  (Turing-Machine #:start 'Start
   [Start 1  1  right Start]
   [Start 0  0  right Start]
   [Start () () left  Add]
   [Add   0  1  stay  End]
   [Add   1  0  left  Add]
   [Add   () 1  stay  End]))
