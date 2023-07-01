CL-USER> (let* ((dog "Benjamin") (Dog "Samba") (DOG "Bernie"))
	   (format nil "There is just one dog named ~a." dog))
; in: LAMBDA NIL
;     (LET* ((DOG "Benjamin") (DOG "Samba") (DOG "Bernie"))
;       (FORMAT NIL "There is just one dog named ~a." DOG))
;
; caught STYLE-WARNING:
;   The variable DOG is defined but never used.
;
; caught STYLE-WARNING:
;   The variable DOG is defined but never used.
;
; compilation unit finished
;   caught 2 STYLE-WARNING conditions
"There is just one dog named Bernie."
