; file:   gui-enable.lsp
; url:    http://rosettacode.org/wiki/GUI_enabling/disabling_of_controls
; author: oofoe 2012-02-02

; Load library and initialize GUI server:
(load (append (env "NEWLISPDIR") "/guiserver.lsp"))
(gs:init)

; The "interlock" function maintains GUI consistency by disabling all
; controls, then selectively re-enabling them depending on the value
; in the textbox.
(define (interlock)
  (gs:disable 'value 'increment 'decrement)
  (let ((v (int (gs:get-text 'value))))
    (if (= 0 v)  (gs:enable 'value))
    (if (< v 10) (gs:enable 'increment))
    (if (< 0 v)  (gs:enable 'decrement))
    ))

; Callbacks.
(define (update f)
  (gs:set-text 'value (string (f (int (gs:get-text 'value)) 1)))
  (interlock))

(define (incrementing id) (update +))

(define (decrementing id) (update -))

(define (valuing id)      (interlock))

; Create main window frame and set layout direction.
(gs:frame 'main 100 100 200 75 "GUI Enable")
(gs:set-flow-layout 'main "center" 4 4)

; Create and add widgets.
(gs:button 'decrement 'decrementing "-" 30)
(gs:text-field 'value 'valuing 8)
(gs:set-text 'value "0")
(gs:button 'increment 'incrementing "+" 30)
(gs:add-to 'main 'decrement 'value 'increment)

; Show main window.
(gs:set-visible 'main true)

; Start event loop.
(gs:listen)

(exit)
