(let ((the-list '(1 7 "foo" 1 4)))	; Set the-list as the list
  (do ((i the-list (rest i)))		; Initialize to the-list and set to rest on every loop
      ((null i))			; Break condition
    (print (first i))))	                ; On every loop print list's first element
