       identification division.
       program-id. prepend.
       data division.
       working-storage section.
       1 str pic x(30) value "World!".
       1 binary.
        2 len pic 9(4) value 0.
        2 scratch pic 9(4) value 0.
       procedure division.
       begin.
           perform rev-sub-str
           move function reverse ("Hello ") to str (len + 1:)
           perform rev-sub-str
           display str
           stop run
           .

       rev-sub-str.
           move 0 to len scratch
           inspect function reverse (str)
           tallying scratch for leading spaces
               len for characters after space
           move function reverse (str (1:len)) to str
           .
       end program prepend.
