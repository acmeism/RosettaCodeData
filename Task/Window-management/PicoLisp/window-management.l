$ ersatz/pil +
: (setq
   JFrame         "javax.swing.JFrame"
   MAXIMIZED_BOTH (java (public JFrame 'MAXIMIZED_BOTH))
   ICONIFIED      (java (public JFrame 'ICONIFIED))
   Win            (java JFrame T "Window") )
-> $JFrame

# Compare for equality
: (== Win Win)
-> T

# Set window visible
(java Win 'setLocation 100 100)
(java Win 'setSize 400 300)
(java Win 'setVisible T)

# Hide window
(java Win 'hide)

# Show again
(java Win 'setVisible T)

# Move window
(java Win 'setLocation 200 200)

# Iconify window
(java Win 'setExtendedState
   (| (java (java Win 'getExtendedState)) ICONIFIED) )

# De-conify window
(java Win 'setExtendedState
   (& (java (java Win 'getExtendedState)) (x| (hex "FFFFFFFF") ICONIFIED)) )

# Maximize window
(java Win 'setExtendedState
   (| (java (java Win 'getExtendedState)) MAXIMIZED_BOTH) )

# Close window
(java Win 'dispose)
