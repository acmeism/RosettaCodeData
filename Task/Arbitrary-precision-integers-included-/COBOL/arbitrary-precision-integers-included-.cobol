       identification division.
       program-id. arbitrary-precision-integers.
       remarks. Uses opaque libgmp internals that are built into libcob.

       data division.
       working-storage section.
       01 gmp-number.
          05 mp-alloc          usage binary-long.
          05 mp-size           usage binary-long.
          05 mp-limb           usage pointer.
       01 gmp-build.
          05 mp-alloc          usage binary-long.
          05 mp-size           usage binary-long.
          05 mp-limb           usage pointer.

       01 the-int              usage binary-c-long unsigned.
       01 the-exponent         usage binary-c-long unsigned.
       01 valid-exponent       usage binary-long value 1.
          88 cant-use          value 0 when set to false 1.

       01 number-string        usage pointer.
       01 number-length        usage binary-long.

       01 window-width         constant as 20.
       01 limit-width          usage binary-long.
       01 number-buffer        pic x(window-width) based.

       procedure division.
       arbitrary-main.

      *> calculate 10 ** 19
       perform initialize-integers.
       display "10 ** 19        : " with no advancing
       move 10 to the-int
       move 19 to the-exponent
       perform raise-pow-accrete-exponent
       perform show-all-or-portion
       perform clean-up

      *> calculate 12345 ** 9
       perform initialize-integers.
       display "12345 ** 9      : " with no advancing
       move 12345 to the-int
       move 9 to the-exponent
       perform raise-pow-accrete-exponent
       perform show-all-or-portion
       perform clean-up

      *> calculate 5 ** 4 ** 3 ** 2
       perform initialize-integers.
       display "5 ** 4 ** 3 ** 2: " with no advancing
       move 3 to the-int
       move 2 to the-exponent
       perform raise-pow-accrete-exponent
       move 4 to the-int
       perform raise-pow-accrete-exponent
       move 5 to the-int
       perform raise-pow-accrete-exponent
       perform show-all-or-portion
       perform clean-up
       goback.
      *> **************************************************************

       initialize-integers.
       call "__gmpz_init" using gmp-number returning omitted
       call "__gmpz_init" using gmp-build returning omitted
       .

       raise-pow-accrete-exponent.
      *> check before using previously overflowed exponent intermediate
       if cant-use then
           display "Error: intermediate overflow occured at "
                   the-exponent upon syserr
           goback
       end-if
       call "__gmpz_set_ui" using gmp-number by value 0
           returning omitted
       call "__gmpz_set_ui" using gmp-build by value the-int
           returning omitted
       call "__gmpz_pow_ui" using gmp-number gmp-build
           by value the-exponent
           returning omitted
       call "__gmpz_set_ui" using gmp-build by value 0
           returning omitted
       call "__gmpz_get_ui" using gmp-number returning the-exponent
       call "__gmpz_fits_ulong_p" using gmp-number
           returning valid-exponent
       .

      *> get string representation, base 10
       show-all-or-portion.
       call "__gmpz_sizeinbase" using gmp-number
           by value 10
           returning number-length
       display "GMP length: " number-length ", " with no advancing

       call "__gmpz_get_str" using null by value 10
           by reference gmp-number
           returning number-string
       call "strlen" using by value number-string
           returning number-length
       display "strlen: " number-length

      *> slide based string across first and last of buffer
       move window-width to limit-width
       set address of number-buffer to number-string
       if number-length <= window-width then
           move number-length to limit-width
           display number-buffer(1:limit-width)
       else
           display number-buffer with no advancing
           subtract window-width from number-length
           move function max(0, number-length) to number-length
           if number-length <= window-width then
               move number-length to limit-width
           else
               display "..." with no advancing
           end-if
           set address of number-buffer up by
               function max(window-width, number-length)
           display number-buffer(1:limit-width)
       end-if
       .

       clean-up.
       call "free" using by value number-string returning omitted
       call "__gmpz_clear" using gmp-number returning omitted
       call "__gmpz_clear" using gmp-build returning omitted
       set address of number-buffer to null
       set cant-use to false
       .

       end program arbitrary-precision-integers.
