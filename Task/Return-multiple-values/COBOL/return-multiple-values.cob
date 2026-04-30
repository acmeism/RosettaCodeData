       identification division.
       program-id. multiple-values.

       environment division.
       configuration section.
       repository.
           function multiples
           function all intrinsic.

       REPLACE ==:linked-items:== BY ==
       01 a usage binary-long.
       01 b pic x(10).
       01 c usage float-short.
       ==
       ==:record-item:== BY ==
       01 master.
          05 ma usage binary-long.
          05 mb pic x(10).
          05 mc usage float-short.
       ==.

       data division.
       working-storage section.
       :linked-items:

       :record-item:

       procedure division.
       sample-main.

       move 41 to a
       move "aaaaabbbbb" to b
       move function e to c

       display "Original: " a ", " b ", " c
       call "subprogram" using a b c
       display "Modified: " a ", " b ", " c

       move multiples() to master
       display "Multiple: " ma ", " mb ", " mc

       goback.
       end program multiple-values.

      *> subprogram
       identification division.
       program-id. subprogram.

       data division.
       linkage section.
       :linked-items:

       procedure division using a b c.
       add 1 to a
       inspect b converting "a" to "b"
       divide 2 into c
       goback.
       end program subprogram.

      *> multiples function
       identification division.
       function-id. multiples.

       data division.
       linkage section.
       :record-item:

       procedure division returning master.
       move 84 to ma
       move "multiple" to mb
       move function pi to mc
       goback.
       end function multiples.
