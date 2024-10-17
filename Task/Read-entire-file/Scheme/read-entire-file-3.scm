(use-modules (ice-9 textual-ports))
(call-with-input-file "foo.txt" get-string-all)
