       identification division.
       program-id. split-ch.
       data division.
       1 split-str pic x(30) value space.
       88 str-1 value "gHHH5YY++///\".
       88 str-2 value "gHHH5  ))YY++,,,///\".
       1 binary.
        2 ptr pic 9(4) value 1.
        2 str-start pic 9(4) value 1.
        2 delim-len pic 9(4) value 1.
        2 split-str-len pic 9(4) value 0.
        2 trash-9 pic 9(4) value 0.
       1 delim-char pic x value space.
       1 delim-str pic x(6) value space.
       1 trash-x pic x.
       procedure division.
           display "Requested string"
           set str-1 to true
           perform split-init-and-go
           display space
           display "With spaces and commas"
           set str-2 to true
           perform split-init-and-go
           stop run
           .

       split-init-and-go.
           move 1 to ptr
           move 0 to split-str-len
           perform split
           .

       split.
           perform get-split-str-len
           display split-str (1:split-str-len)
           perform until ptr > split-str-len
               move ptr to str-start
               move split-str (ptr:1) to delim-char
               unstring split-str (1:split-str-len)
                   delimited all delim-char
                   into trash-x delimiter delim-str
                   pointer ptr
               end-unstring
               subtract str-start from ptr giving delim-len
               move split-str (str-start:delim-len)
                   to delim-str (1:delim-len)
               display delim-str (1:delim-len) with no advancing
               if ptr <= split-str-len
                   display ", " with no advancing
               end-if
           end-perform
           display space
           .

       get-split-str-len.
           inspect function reverse (split-str) tallying
               trash-9 for leading space
               split-str-len for characters after space
           .

       end program split-ch.
