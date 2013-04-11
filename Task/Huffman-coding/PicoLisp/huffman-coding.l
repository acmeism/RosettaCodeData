(de prio (Idx)
   (while (cadr Idx) (setq Idx @))
   (car Idx) )

(let (A NIL  P NIL  L NIL)
   (for C (chop "this is an example for huffman encoding")
      (accu 'A C 1) )                  # Count characters
   (for X A                            # Build index tree as priority queue
      (idx 'P (cons (cdr X) (car X)) T) )
   (while (or (cadr P) (cddr P))       # Remove entries, insert as nodes
      (let (A (car (idx 'P (prio P) NIL))  B (car (idx 'P (prio P) NIL)))
         (idx 'P (cons (+ (car A) (car B)) A B) T) ) )
   (setq P (car P))
   (recur (P L)                        # Traverse and print
      (if (atom (cdr P))
         (prinl (cdr P)  " " L)
         (recurse (cadr P) (cons 0 L))
         (recurse (cddr P) (cons 1 L)) ) ) )
