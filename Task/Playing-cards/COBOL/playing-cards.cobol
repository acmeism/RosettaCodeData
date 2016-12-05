       identification division.
       program-id. playing-cards.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       77 card             usage index.
       01 deck.
          05 cards occurs 52 times ascending key slot indexed by card.
             10 slot       pic 99.
             10 hand       pic 99.
             10 suit       pic 9.
             10 symbol     pic x(4).
             10 rank       pic 99.

       01 filler.
          05 suit-name     pic x(8) occurs 4 times.

      *> Unicode U+1F0Ax, Bx, Cx, Dx "f09f82a0" "82b0" "8380" "8390"
       01 base-s           constant as 4036985504.
       01 base-h           constant as 4036985520.
       01 base-d           constant as 4036985728.
       01 base-c           constant as 4036985744.

       01 sym              pic x(4) comp-x.
       01 symx             redefines sym pic x(4).
       77 s                pic 9.
       77 r                pic 99.
       77 c                pic 99.
       77 hit              pic 9.
       77 limiter          pic 9(6).

       01 spades           constant as 1.
       01 hearts           constant as 2.
       01 diamonds         constant as 3.
       01 clubs            constant as 4.

       01 players          constant as 3.
       01 cards-per        constant as 5.
       01 deal             pic 99.
       01 player           pic 99.

       01 show-tally       pic zz.
       01 show-rank        pic z(5).
       01 arg              pic 9(10).

       procedure division.
       cards-main.
       perform seed
       perform initialize-deck
       perform shuffle-deck
       perform deal-deck
       perform display-hands
       goback.

      *> ********
       seed.
           accept arg from command-line
           if arg not equal 0 then
               move random(arg) to c
           end-if
       .

       initialize-deck.
           move "spades" to suit-name(spades)
           move "hearts" to suit-name(hearts)
           move "diamonds" to suit-name(diamonds)
           move "clubs" to suit-name(clubs)

           perform varying s from 1 by 1 until s > 4
                     after r from 1 by 1 until r > 13
                   compute c = (s - 1) * 13 + r
                   evaluate s
                       when spades compute sym = base-s + r
                       when hearts compute sym = base-h + r
                       when diamonds compute sym = base-d + r
                       when clubs compute sym = base-c + r
                   end-evaluate
                   if r > 11 then compute sym = sym + 1 end-if
                   move s to suit(c)
                   move r to rank(c)
                   move symx to symbol(c)
                   move zero to slot(c)
                   move zero to hand(c)
           end-perform
       .

       shuffle-deck.
           move zero to limiter
           perform until exit
               compute c = random() * 52.0 + 1.0
               move zero to hit
               perform varying tally from 1 by 1 until tally > 52
                   if slot(tally) equal c then
                       move 1 to hit
                       exit perform
                   end-if
                   if slot(tally) equal 0 then
                       if tally < 52 then move 1 to hit end-if
                       move c to slot(tally)
                       exit perform
                   end-if
               end-perform
               if hit equal zero then exit perform end-if
               if limiter > 999999 then
                   display "too many shuffles, deck invalid" upon syserr
                   exit perform
               end-if
               add 1 to limiter
           end-perform
           sort cards ascending key slot
       .

       display-card.
       >>IF ENGLISH IS DEFINED
               move rank(tally) to show-rank
               evaluate rank(tally)
                   when 1 display "  ace" with no advancing
                   when 2 thru 10 display show-rank with no advancing
                   when 11 display " jack" with no advancing
                   when 12 display "queen" with no advancing
                   when 13 display " king" with no advancing
               end-evaluate
               display " of " suit-name(suit(tally)) with no advancing
       >>ELSE
               display symbol(tally) with no advancing
       >>END-IF
       .

       display-deck.
           perform varying tally from 1 by 1 until tally > 52
               move tally to show-tally
               display "Card: " show-tally
                       " currently in hand " hand(tally)
                       " is " with no advancing
               perform display-card
               display space
           end-perform
       .

       display-hands.
           perform varying player from 1 by 1 until player > players
               move player to tally
               display "Player " player ": " with no advancing
               perform varying deal from 1 by 1 until deal > cards-per
                  perform display-card
                  add players to tally
               end-perform
               display space
           end-perform
           display "Stock: " with no advancing
           subtract players from tally
           add 1 to tally
           perform varying tally from tally by 1 until tally > 52
               perform display-card
       >>IF ENGLISH IS DEFINED
               display space
       >>END-IF
           end-perform
           display space
       .

       deal-deck.
           display "Dealing " cards-per " cards to " players " players"
           move 1 to tally
           perform varying deal from 1 by 1 until deal > cards-per
                     after player from 1 by 1 until player > players
               move player to hand(tally)
               add 1 to tally
           end-perform
       .

       end program playing-cards.
