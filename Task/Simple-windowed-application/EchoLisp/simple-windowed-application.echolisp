(define (ui-add-button text) ;; helper
    (define b (ui-create-element "button" '((type "button"))))
    (ui-set-html b text)
    (ui-add b))

(define (panel )
    (ui-clear)
    (define *clicks* 0)
    (define text (ui-create-element "span" '((style "font-weight:bold"))))
    (ui-add text)
    (ui-set-html text "No click yet")

    (define btn (ui-add-button "Click-me"))
    (define (count-clicks elem)
        (++ *clicks*)
        (ui-set-html text *clicks*))
    (ui-on-click btn count-clicks)

    (stdout-hide #t)
    (stdin-hide #t)) ;; end panel definition

(panel)
