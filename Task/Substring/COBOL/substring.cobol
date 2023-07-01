       identification division.
       program-id. substring.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 original.
          05 value "this is a string".
       01 starting  pic 99 value 3.
       01 width     pic 99 value 8.
       01 pos       pic 99.
       01 ender     pic 99.
       01 looking   pic 99.
       01 indicator pic x.
          88 found  value high-value when set to false is low-value.
       01 look-for  pic x(8).

       procedure division.
       substring-main.

       display "Original |" original "|, n = " starting " m = " width
       display original(starting : width)
       display original(starting :)
       display original(1 : length(original) - 1)

       move "a" to look-for
       move 1 to looking
       perform find-position
       if found
           display original(pos : width)
       end-if

       move "is a st" to look-for
       move length(trim(look-for)) to looking
       perform find-position
       if found
           display original(pos : width)
       end-if
       goback.

       find-position.
       set found to false
       compute ender = length(original) - looking
       perform varying pos from 1 by 1 until pos > ender
           if original(pos : looking) equal look-for then
               set found to true
               exit perform
           end-if
       end-perform
       .

       end program substring.
