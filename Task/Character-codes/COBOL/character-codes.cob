       identification division.
       program-id. character-codes.
       remarks. COBOL is an ordinal language, first is 1.
       remarks. 42nd ASCII code is ")" not, "*".
       procedure division.
       display function char(42)
       display function ord('*')
       goback.
       end program character-codes.
