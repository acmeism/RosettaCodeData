       identification division.
       program-id. caesar.
       data division.
       1 msg pic x(50)
           value "The quick brown fox jumped over the lazy dog.".
       1 offset binary pic 9(4) value 7.
       1 from-chars pic x(52).
       1 to-chars pic x(52).
       1 tabl.
        2 pic x(26) value "abcdefghijklmnopqrstuvwxyz".
        2 pic x(26) value "ABCDEFGHIJKLMNOPQRSTUVWXYZ".
        2 pic x(26) value "abcdefghijklmnopqrstuvwxyz".
        2 pic x(26) value "ABCDEFGHIJKLMNOPQRSTUVWXYZ".
       procedure division.
       begin.
           display msg
           perform encrypt
           display msg
           perform decrypt
           display msg
           stop run
           .

       encrypt.
           move tabl (1:52) to from-chars
           move tabl (1 + offset:52) to to-chars
           inspect msg converting from-chars
               to to-chars
           .

       decrypt.
           move tabl (1 + offset:52) to from-chars
           move tabl (1:52) to to-chars
           inspect msg converting from-chars
               to to-chars
           .
       end program caesar.
