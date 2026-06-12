#lang racket
(require (planet dyoo/suffixtree))
(define tree (make-tree))
(tree-add! tree (string->label "banana$"))

(define (show-node nd dpth)
  (define children (node-children nd))
  (printf "~a~a ~a~%" (match dpth
                        [(regexp #px"(.*) $" (list _ d)) (string-append d "`")]
                        [else else]) (if (null? children) "--" "-+") (label->string (node-up-label nd)))
  (let l ((children children))
    (match children
      ((list) (void))
      ((list c) (show-node c (string-append dpth "  ")))
      ((list c ct ...) (show-node c (string-append dpth " |")) (l ct)))))

(show-node (tree-root tree) "")
