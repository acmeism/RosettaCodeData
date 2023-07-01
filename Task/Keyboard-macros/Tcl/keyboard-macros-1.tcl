package require Tk
# Show off some emacs-like bindings...
pack [label .l -text "C-x C-s to save, C-x C-c to quit"]
focus .
bind . <Control-x><Control-s> {
    tk_messageBox -message "We would save here"
}
bind . <Control-x><Control-c> {exit}
