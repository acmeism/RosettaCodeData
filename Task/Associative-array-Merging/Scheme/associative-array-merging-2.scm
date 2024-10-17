; Merge the given alists.  Prefer the items from the "update" alist.
; Returns a new list; the argument lists are not modified.
(define merge-alists
  (lambda (base update)
    (let ((merged (list-copy update))
          (remains (list-copy base)))
      (let loop ((shadowing merged))
        (if (null? shadowing)
          (append merged remains)
          (begin (set! remains (remp (lambda (pair) (equal? (car pair) (caar shadowing)))
                                     remains))
                 (loop (cdr shadowing))))))))

; Test...
(printf "~%Merge using defined merge-alists procedure...~%")
; The original base and update alists.
(let ((base '(("name" . "Rocket Skates") ("price" . 12.75) ("color" . "yellow" )))
      (update '(("price" . 15.25) ("color" . "red") ("year" . 1974))))
  ; Merge using the defined merge-alists procedure.
  (let ((merged (merge-alists base update)))
    ; Show that everything worked.
    (printf "Merged alist:~%~s~%" merged)
    (printf "Values from merged alist:~%")
    (let loop ((keys '("name" "price" "color" "year")))
      (unless (null? keys)
        (printf "~s -> ~s~%" (car keys) (cdr (assoc (car keys) merged)))
        (loop (cdr keys))))))
