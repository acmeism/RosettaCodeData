       program-id. dsp-str is external.
       data division.
       linkage section.
       1 cnt comp-5 pic 9(4).
       1 str pic x.
       procedure division using by value cnt
           by reference str delimited repeated 1 to 5.
       end program dsp-str.

       program-id. variadic.
       procedure division.
           call "dsp-str" using 4 "The" "quick" "brown" "fox"
           stop run
           .
       end program variadic.

       program-id. dsp-str.
       data division.
       working-storage section.
       1 i comp-5 pic 9(4).
       1 len comp-5 pic 9(4).
       1 wk-string pic x(20).
       linkage section.
       1 cnt comp-5 pic 9(4).
       1 str1 pic x(20).
       1 str2 pic x(20).
       1 str3 pic x(20).
       1 str4 pic x(20).
       1 str5 pic x(20).
       procedure division using cnt str1 str2 str3 str4 str5.
           if cnt < 1 or > 5
               display "Invalid number of parameters"
               stop run
           end-if
           perform varying i from 1 by 1
           until i > cnt
               evaluate i
               when 1
                   unstring str1 delimited low-value
                   into wk-string count in len
               when 2
                   unstring str2 delimited low-value
                   into wk-string count in len
               when 3
                   unstring str3 delimited low-value
                   into wk-string count in len
               when 4
                   unstring str4 delimited low-value
                   into wk-string count in len
               when 5
                   unstring str5 delimited low-value
                   into wk-string count in len
               end-evaluate
               display wk-string (1:len)
           end-perform
           exit program
           .
       end program dsp-str.
