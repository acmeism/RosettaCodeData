(import (scheme char))

(define (comp a b)
   (string-ci<? (a 'name #f) (b 'name #f)))

(for-each print
   (sort comp (list
      { 'name "David"
        'value "Manager" }
      { 'name "Alice"
        'value "Sales" }
      { 'name "Joanna"
        'value "Director" }
      { 'name "Henry"
        'value "Admin" }
      { 'name "Tim"
        'value "Sales" }
      { 'name "Juan"
        'value "Admin" })))
