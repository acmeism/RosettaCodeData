(set 'in-file (open "filename" "read"))
(while (read-line in-file)
       (write-line))
(close in-file)
