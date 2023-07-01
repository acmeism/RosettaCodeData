       program-id. rev-word.
       data division.
       working-storage section.
       1 text-block.
        2 pic x(36) value "---------- Ice and Fire ------------".
        2 pic x(36) value "                                    ".
        2 pic x(36) value "fire, in end will world the say Some".
        2 pic x(36) value "ice. in say Some                    ".
        2 pic x(36) value "desire of tasted I've what From     ".
        2 pic x(36) value "fire. favor who those with hold I   ".
        2 pic x(36) value "                                    ".
        2 pic x(36) value "... elided paragraph last ...       ".
        2 pic x(36) value "                                    ".
        2 pic x(36) value "Frost Robert -----------------------".
       1 redefines text-block.
        2 occurs 10.
         3 text-line pic x(36).
       1 text-word.
        2 wk-len binary pic 9(4).
        2 wk-word pic x(36).
       1 word-stack.
        2 occurs 10.
         3 word-entry.
          4 word-len binary pic 9(4).
          4 word pic x(36).
       1 binary.
        2 i pic 9(4).
        2 pos pic 9(4).
        2 word-stack-ptr pic 9(4).

       procedure division.
           perform varying i from 1 by 1
           until i > 10
               perform push-words
               perform pop-words
           end-perform
           stop run
           .

       push-words.
           move 1 to pos
           move 0 to word-stack-ptr
           perform until pos > 36
               unstring text-line (i) delimited by all space
               into wk-word count in wk-len
               pointer pos
               end-unstring
               add 1 to word-stack-ptr
               move text-word to word-entry (word-stack-ptr)
           end-perform
           .

       pop-words.
           perform varying word-stack-ptr from word-stack-ptr
               by -1
           until word-stack-ptr < 1
               move word-entry (word-stack-ptr) to text-word
               display wk-word (1:wk-len) space with no advancing
           end-perform
           display space
           .
       end program rev-word.
