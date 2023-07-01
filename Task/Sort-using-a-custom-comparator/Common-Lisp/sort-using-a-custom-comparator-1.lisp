CL-USER> (defvar *strings*
                 (list "Cat" "apple" "Adam" "zero" "Xmas" "quit" "Level" "add" "Actor" "base" "butter"))
*STRINGS*
CL-USER> (sort *strings* #'string-lessp)
("Actor" "Adam" "add" "apple" "base" "butter" "Cat" "Level" "quit" "Xmas"
"zero")
