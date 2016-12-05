       identification division.
       program-id. show-continued-fractions.

       environment division.
       configuration section.
       repository.
           function continued-fractions
           function all intrinsic.

       procedure division.
       fractions-main.

       display "Square root 2 approximately   : "
               continued-fractions("sqrt-2-alpha", "sqrt-2-beta", 100)
       display "Napier constant approximately : "
               continued-fractions("napier-alpha", "napier-beta", 40)
       display "Pi approximately              : "
               continued-fractions("pi-alpha", "pi-beta", 10000)

       goback.
       end program show-continued-fractions.

      *> **************************************************************
       identification division.
       function-id. continued-fractions.

       data division.
       working-storage section.
       01 alpha-function       usage program-pointer.
       01 beta-function        usage program-pointer.
       01 alpha                usage float-long.
       01 beta                 usage float-long.
       01 running              usage float-long.
       01 i                    usage binary-long.

       linkage section.
       01 alpha-name           pic x any length.
       01 beta-name            pic x any length.
       01 iterations           pic 9 any length.
       01 approximation        usage float-long.

       procedure division using
           alpha-name beta-name iterations
           returning approximation.

       set alpha-function to entry alpha-name
       if alpha-function = null then
           display "error: no " alpha-name " function" upon syserr
           goback
       end-if
       set beta-function to entry beta-name
       if beta-function = null then
           display "error: no " beta-name " function" upon syserr
           goback
       end-if

       move 0 to alpha beta running
       perform varying i from iterations by -1 until i = 0
           call alpha-function using i returning alpha
           call beta-function using i returning beta
           compute running = beta / (alpha + running)
       end-perform
       call alpha-function using 0 returning alpha
       compute approximation = alpha + running

       goback.
       end function continued-fractions.

      *> ******************************
       identification division.
       program-id. sqrt-2-alpha.

       data division.
       working-storage section.
       01 result               usage float-long.

       linkage section.
       01 iteration            usage binary-long unsigned.

       procedure division using iteration returning result.
       if iteration equal 0 then
           move 1.0 to result
       else
           move 2.0 to result
       end-if

       goback.
       end program sqrt-2-alpha.

      *> ******************************
       identification division.
       program-id. sqrt-2-beta.

       data division.
       working-storage section.
       01 result               usage float-long.

       linkage section.
       01 iteration            usage binary-long unsigned.

       procedure division using iteration returning result.
       move 1.0 to result

       goback.
       end program sqrt-2-beta.

      *> ******************************
       identification division.
       program-id. napier-alpha.

       data division.
       working-storage section.
       01 result               usage float-long.

       linkage section.
       01 iteration            usage binary-long unsigned.

       procedure division using iteration returning result.
       if iteration equal 0 then
           move 2.0 to result
       else
           move iteration to result
       end-if

       goback.
       end program napier-alpha.

      *> ******************************
       identification division.
       program-id. napier-beta.

       data division.
       working-storage section.
       01 result               usage float-long.

       linkage section.
       01 iteration            usage binary-long unsigned.

       procedure division using iteration returning result.
       if iteration = 1 then
           move 1.0 to result
       else
           compute result = iteration - 1.0
       end-if

       goback.
       end program napier-beta.

      *> ******************************
       identification division.
       program-id. pi-alpha.

       data division.
       working-storage section.
       01 result               usage float-long.

       linkage section.
       01 iteration            usage binary-long unsigned.

       procedure division using iteration returning result.
       if iteration equal 0 then
           move 3.0 to result
       else
           move 6.0 to result
       end-if

       goback.
       end program pi-alpha.

      *> ******************************
       identification division.
       program-id. pi-beta.

       data division.
       working-storage section.
       01 result               usage float-long.

       linkage section.
       01 iteration            usage binary-long unsigned.

       procedure division using iteration returning result.
       compute result = (2 * iteration - 1) ** 2

       goback.
       end program pi-beta.
