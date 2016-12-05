CL-USER> (defvar *strings*
                 (list "Cat" "apple" "Adam" "zero" "Xmas" "quit" "Level" "add" "Actor" "base" "butter"))
*STRINGS*
CL-USER> (sort *strings* #'> :key #'length)
("butter" "apple" "Level" "Actor" "Adam" "zero" "Xmas" "quit" "base"
 "Cat" "add")
