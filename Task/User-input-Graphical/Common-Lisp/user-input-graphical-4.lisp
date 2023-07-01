(capi:define-interface string/integer-prompt () ()
  (:panes
   (string-pane
    capi:text-input-pane
    :title "Enter a string:")
   (integer-pane
    capi:text-input-pane
    :title "Enter an integer:"
    :change-callback :redisplay-interface))
  (:layouts
   (main
    capi:column-layout
    '(string-pane integer-pane))))
