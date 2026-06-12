       identification division.
       program-id. rexxtrial.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.

       procedure division.
      *> First attempt fails and return statement does not execute
       display rexx("ADDRESS SYSTEM; 'ls rexxtrial.cob'; return 'fail'")
       display "Exception: " exception-status

      *> Second is allowed and succeeds
       display "Try with rexx-unrestricted"
       display rexx-unrestricted(
           "ADDRESS SYSTEM; 'ls -l rexxtrial.cob'; return 'success'")
       display "No exception raised: " exception-status
       goback.
       end program rexxtrial.
