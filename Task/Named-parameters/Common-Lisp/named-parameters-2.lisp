CL-USER> (print-name)
?
CL-USER> (print-name :first "John")
?, John
CL-USER> (print-name :first "John" :last "Doe")
Doe, John
CL-USER> (print-name :last "Doe")
Doe
