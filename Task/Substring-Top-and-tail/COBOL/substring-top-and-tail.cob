       identification division.
       program-id. toptail.

       data division.
       working-storage section.
       01 data-field.
          05 value "[this is a test]".

       procedure division.
       sample-main.
       display data-field
      *> Using reference modification, which is (start-position:length)
       display data-field(2:)
       display data-field(1:length of data-field - 1)
       display data-field(2:length of data-field - 2)
       goback.
       end program toptail.
