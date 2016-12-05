       program-id. phra-rev.
       data division.
       working-storage section.
       1 phrase pic x(28) value "rosetta code phrase reversal".
       1 wk-str pic x(16).
       1 binary.
        2 phrase-len pic 9(4).
        2 pos pic 9(4).
        2 cnt pic 9(4).
       procedure division.
           compute phrase-len = function length (phrase)
           display phrase
           display function reverse (phrase)
           perform display-words
           move function reverse (phrase) to phrase
           perform display-words
           stop run
           .

       display-words.
           move 1 to pos
           perform until pos > phrase-len
               unstring phrase delimited space
               into wk-str count in cnt
               with pointer pos
               end-unstring
               display function reverse (wk-str (1:cnt))
                   with no advancing
               if pos < phrase-len
                   display space with no advancing
               end-if
           end-perform
           display space
           .
       end program phra-rev.
