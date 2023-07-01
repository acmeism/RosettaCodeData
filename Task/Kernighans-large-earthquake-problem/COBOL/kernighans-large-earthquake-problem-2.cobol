      *>
      *> Tectonics: ./kerighan-earth-quakes <quakes.txt
       identification division.
       program-id. quakes.

       data division.

       working-storage section.
       01 data-line pic x(32768).
          88 no-more value high-values.

       01 date-time pic x(10).
       01 quake pic x(20).
       01 magnitude pic 99v99.

       procedure division.
       show-big-ones.

       accept data-line on exception set no-more to true end-accept
       perform until no-more
           unstring data-line delimited by all spaces
              into date-time quake magnitude
           end-unstring

           if magnitude greater than 6
               display date-time space quake space magnitude
           end-if

           accept data-line on exception set no-more to true end-accept
       end-perform

       goback.
       end program quakes.
