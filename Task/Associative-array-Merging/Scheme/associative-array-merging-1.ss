; Merge alists by appending the update list onto the front of the base list.
; (The extra '() is so that append doesn't co-opt the second list.)
(define append-alists
  (lambda (base update)
    (append update base '())))

; Test...
(printf "~%Merge using append procedure...~%")
; The original base and update alists.
(let ((base '(("name" . "Rocket Skates") ("price" . 12.75) ("color" . "yellow" )))
      (update '(("price" . 15.25) ("color" . "red") ("year" . 1974))))
  ; Merge by appending the update list onto the front of the base list.
  (let ((merged (append-alists base update)))
    ; Show that everything worked.
    (printf "Merged alist:~%~s~%" merged)
    (printf "Values from merged alist:~%")
    (let loop ((keys '("name" "price" "color" "year")))
      (unless (null? keys)
        (printf "~s -> ~s~%" (car keys) (cdr (assoc (car keys) merged)))
        (loop (cdr keys))))))
