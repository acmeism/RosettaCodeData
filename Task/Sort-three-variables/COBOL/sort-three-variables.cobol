       program-id. 3var.
       data division.
       working-storage section.
       1 n binary pic 9(4).
       1 num pic -(7)9.
       1 a1 pic x(32) value "lions, tigers, and".
       1 a2 pic x(32) value "bears, oh my!".
       1 a3 pic x(32) value "(from the ""Wizard of OZ"")".
       1 n1 pic x(8) value "77444".
       1 n2 pic x(8) value "-12".
       1 n3 pic x(8) value "0".
       1 alpha-table.
        2 alpha-entry occurs 3 pic x(32).
       1 numeric-table.
        2 numeric-entry occurs 3 pic s9(8).
       1 filler value "x = y = z = ".
        2 lead-in occurs 3 pic x(4).
       procedure division.
       begin.
           move a1 to alpha-entry (1)
           move a2 to alpha-entry (2)
           move a3 to alpha-entry (3)
           sort alpha-entry ascending alpha-entry
           perform varying n from 1 by 1
           until n > 3
               display lead-in (n) alpha-entry (n)
           end-perform

           display space

           compute numeric-entry (1) = function numval (n1)
           compute numeric-entry (2) = function numval (n2)
           compute numeric-entry (3) = function numval (n3)
           sort numeric-entry ascending numeric-entry
           perform varying n from 1 by 1
           until n > 3
               move numeric-entry (n) to num
               display lead-in (n) num
           end-perform

           stop run
           .
       end program 3var.
