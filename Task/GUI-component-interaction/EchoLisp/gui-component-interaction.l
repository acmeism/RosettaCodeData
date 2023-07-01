(require 'interface)

;; helper new button with text
(define (ui-add-button text)
    (define b (ui-create-element "button" '((type "button"))))
    (ui-set-html b text)
    (ui-add b))


(define (panel )
    (ui-clear)
    (info-text "My rosetta application" "blue")

;; input field (checked for numeric)
    (define f-input (ui-create-element "input" '((type number))))
    (ui-set-value f-input 0)
    (ui-add f-input)
    (ui-on-focus  f-input (lambda(e) (info-text "")))

;; Increment button
    (define btn-inc (ui-add-button "Increment"))
    (define (increment elem)
        (define val (ui-get-numvalue f-input))
        (if val ;; checked legal numeric
                (ui-set-value f-input (1+ val))
                (info-text  "Need a number" "red")))
    (ui-on-click btn-inc increment)
    (ui-add btn-inc)

    (define btn-random (ui-add-button "Random"))
    (define (set-random elem)
        (when (confirm "Really random?")
              (ui-set-value f-input (random-prime 1000000))))
    (ui-on-click btn-random set-random)

    (ui-focus btn-inc)
    (stdout-hide #t)
    (stdin-hide #t)) ;; end panel

(panel)
