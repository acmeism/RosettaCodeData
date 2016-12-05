;; reboot (close the browser window)
; inspect objects.dat :
(local-keys 'objects.dat) → ("elvis" "papa" "simon")

(define simon (local-get-value 'simon "objects.dat"))
(define elvis (local-get-value 'elvis "objects.dat"))
(define papa (local-get-value 'papa "objects.dat"))

; data are restored
simon → Simon: writer of (my-life my-wife my-bike).
papa → papa: father of (Simon Elvis).

;; check if references (pointers) are restored
(set-writer-name! simon "Antoinette") → "Antoinette"
simon→ Antoinette: writer of (my-life my-wife my-bike).

;; inspect
papa → papa: father of (Antoinette Elvis). ; YES 😳 !

;; - Self-referencing  (EchoLisp version 2.11)
;; add 'papa' to the chidren of 'papa' - whatever this means - and print it :
(set-father-children! papa (list simon papa elvis))
papa → papa: father of (Antoinette papa Elvis).

; save/restore
(local-put-value 'papa papa "objects.dat")
(define papa (local-get-value 'papa "objects.dat"))
papa → papa: father of (Antoinette papa Elvis).
