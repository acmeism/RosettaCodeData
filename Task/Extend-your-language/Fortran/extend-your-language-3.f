      SELECT CASE(IF2(A,B))
       CASE(B"00"); WRITE (6,*) "Both false."
       CASE(B"01"); WRITE (6,*) "B only."
       CASE(B"10"); WRITE (6,*) "A only."
       CASE(B"11"); WRITE (6,*) "Both true."
      END SELECT
