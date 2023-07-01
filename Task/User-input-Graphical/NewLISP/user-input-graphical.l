; file:   input-gui.lsp
; url:    http://rosettacode.org/wiki/User_input/Graphical
; author: oofoe 2012-02-02

; Colours
(setq  ok '(.8 1 .8)  fail '(1 .5 .5))

; Load library and initialize GUI server:
(load (append (env "NEWLISPDIR") "/guiserver.lsp"))
(gs:init)

; Validation Callback

; There is a bug in the "gs:get-text" function that causes it to fail
; silently if the text field is empty. Therfore, I set the field
; background to red first and only clear it if the field returns
; correctly.
(define (validate)
  (gs:set-color 'string fail)
  (if (not (empty? (gs:get-text 'string)))
      (gs:set-color 'string ok))

  (gs:set-color 'number fail)
  (if (= 75000 (int (gs:get-text 'number)))
      (gs:set-color 'number ok))
  )

; Create main window frame and set layout.
(gs:frame 'main 100 100 256 128 "User Input/Graphical")
(gs:set-flow-layout 'main "left" 4 4)

; Create and add widgets.
(gs:label 'instructions "Please enter a string and the number 75000:")
(gs:text-field 'string 'validate 32)
(gs:text-field 'number 'validate 8)
(gs:button 'check 'validate "validate...")
(gs:add-to 'main 'instructions 'string 'number 'check)

; Show main window.
(gs:set-visible 'main true)

; Start event loop.
(gs:listen)

; No (exit) needed -- guiserver kills program on window close.
