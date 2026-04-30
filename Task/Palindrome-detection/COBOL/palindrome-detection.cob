       identification division.
       function-id. palindromic-test.

       data division.
       linkage section.
       01 test-text            pic x any length.
       01 result               pic x.
          88 palindromic       value high-value
                               when set to false low-value.

       procedure division using test-text returning result.

       set palindromic to false
       if test-text equal function reverse(test-text) then
           set palindromic to true
       end-if

       goback.
       end function palindromic-test.
