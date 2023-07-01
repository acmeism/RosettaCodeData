; hello-gui.lsp
; oofoe 2012-01-18

; Initialize GUI server.
(load (append (env "NEWLISPDIR") "/guiserver.lsp"))
(gs:init)

; Create window frame.
(gs:frame 'Goodbye 100 100 300 200 "Goodbye!")
(gs:set-resizable 'Goodbye nil)
(gs:set-flow-layout 'Goodbye "center")

; Add final message.
(gs:label 'Message "Goodbye, World!" "center")
(gs:add-to 'Goodbye 'Message)

; Show frame.
(gs:set-visible 'Goodbye true)

; Start event loop.
(gs:listen)

(exit) ; NewLisp normally goes to listener after running script.
