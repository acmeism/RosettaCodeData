(cond-expand
  (r7rs)
  (chicken (import r7rs)))

(import (scheme base))
(import (scheme write))
(import (scheme case-lambda))
(import (scheme process-context))

;; A doubly-linked list will be represented by a reference to any of
;; its nodes. This is possible because the "root node" is marked as
;; such.
(define-record-type <dllist>
  (%dllist root? prev next element)
  dllist?
  (root? dllist-root?)
  (prev dllist-prev %dllist-set-prev!)
  (next dllist-next %dllist-set-next!)
  (element %dllist-element))

(define (dllist-element node)
  ;; Get the element in a node. It is an error if the node is the
  ;; root.
  (when (dllist-root? node)
    (display "dllist-element of a root node\n" (current-error-port))
    (exit 1))
  (%dllist-element node))

(define (dllist . elements)
  ;; Make a doubly-linked list from the given elements.
  (list->dllist elements))

(define (make-dllist)
  ;; Return a node marked as being a root, and which points to itself.
  (let ((root (%dllist #t #f #f #f)))
    (%dllist-set-prev! root root)
    (%dllist-set-next! root root)
    root))

(define (dllist-root node)
  ;; Given a reference to any node of a <dllist>, return a reference
  ;; to the list's root node.
  (if (dllist-root? node)
      node
      (dllist-root (dllist-prev node))))

(define (dllist-insert-after! node element)
  ;; Insert an element after the given node, which may be either the
  ;; root or some other node.
  (let* ((next-node (dllist-next node))
         (new-node (%dllist #f node next-node element)))
    (%dllist-set-next! node new-node)
    (%dllist-set-prev! next-node new-node)))

(define (dllist-insert-before! node element)
  ;; Insert an element before the given node, which may be either the
  ;; root or some other node.
  (let* ((prev-node (dllist-prev node))
         (new-node (%dllist #f prev-node node element)))
    (%dllist-set-next! prev-node new-node)
    (%dllist-set-prev! node new-node)))

(define (dllist-remove! node)
  ;; Remove a node from a <dllist>. It is an error if the node is the
  ;; root.
  (when (dllist-root? node)
    (display "dllist-remove! of a root node\n" (current-error-port))
    (exit 1))
  (let ((prev (dllist-prev node))
        (next (dllist-next node)))
    (%dllist-set-next! prev next)
    (%dllist-set-prev! next prev)))

(define dllist-make-generator
  ;; Make a thunk that returns the elements of the list, starting at
  ;; the root and going in either direction.
  (case-lambda
    ((node) (dllist-make-generator node 1))
    ((node direction)
     (if (negative? direction)
         (let ((p (dllist-prev (dllist-root node))))
           (lambda ()
             (and (not (dllist-root? p))
                  (let ((element (dllist-element p)))
                    (set! p (dllist-prev p))
                    element))))
         (let ((p (dllist-next (dllist-root node))))
           (lambda ()
             (and (not (dllist-root? p))
                  (let ((element (dllist-element p)))
                    (set! p (dllist-next p))
                    element))))))))

(define (list->dllist lst)
  ;; Make a doubly-linked list from the elements of an ordinary list.
  (let loop ((node (make-dllist))
             (lst lst))
    (if (null? lst)
        (dllist-next node)
        (begin
          (dllist-insert-after! node (car lst))
          (loop (dllist-next node) (cdr lst))))))

(define (dllist->list node)
  ;; Make an ordinary list from the elements of a doubly-linked list.
  (let loop ((lst '())
             (node (dllist-prev (dllist-root node))))
    (if (dllist-root? node)
        lst
        (loop (cons (dllist-element node) lst) (dllist-prev node)))))

;;;
;;; Some demonstration.
;;;

(define (print-it node)
  (let ((gen (dllist-make-generator node)))
    (do ((x (gen) (gen)))
        ((not x))
      (display " ")
      (write x))
    (newline)))

(define dl (dllist 10 20 30 40 50))

(let ((gen (dllist-make-generator dl)))
  (display "forwards generator: ")
  (do ((x (gen) (gen)))
      ((not x))
    (display " ")
    (write x))
  (newline))

(let ((gen (dllist-make-generator dl -1)))
  (display "backwards generator:")
  (do ((x (gen) (gen)))
      ((not x))
    (display " ")
    (write x))
  (newline))

(display "insertion after the root: ")
(dllist-insert-after! dl 5)
(print-it dl)

(display "insertion before the root:")
(dllist-insert-before! dl 55)
(print-it dl)

(display "insertion after the second element:")
(dllist-insert-after! (dllist-next (dllist-next dl)) 15)
(print-it dl)

(display "insertion before the second from last element:")
(dllist-insert-before! (dllist-prev (dllist-prev dl)) 45)
(print-it dl)

(display "removal of the element 30:")
(let ((node (let loop ((node (dllist-next dl)))
              (if (= (dllist-element node) 30)
                  node
                  (loop (dllist-next node))))))
  (dllist-remove! node))
(print-it dl)

(display "any node can be used for the generator:")
(print-it (dllist-next (dllist-next (dllist-next dl))))

(display "conversion to a list: ")
(display (dllist->list dl))
(newline)

(display "conversion from a list:")
(print-it (list->dllist (list "a" "b" "c")))
