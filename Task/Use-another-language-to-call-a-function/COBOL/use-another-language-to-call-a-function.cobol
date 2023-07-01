       identification division.
       program-id. Query.

       environment division.
       configuration section.
       special-names.
           call-convention 0 is extern.

       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 query-result.
          05 filler value "Here I am".

       linkage section.
       01 data-reference.
          05 data-buffer   pic x occurs 0 to 8192 times
                                 depending on length-reference.
       01 length-reference usage binary-long.

       procedure division extern using data-reference length-reference.

       if length(query-result) less than or equal to length-reference
                           and length-reference less than 8193 then
           move query-result to data-reference
           move length(query-result) to length-reference
           move 1 to return-code
       end-if

       goback.
       end program Query.
