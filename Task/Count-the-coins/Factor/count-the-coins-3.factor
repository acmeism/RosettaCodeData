USING: arrays locals math math.ranges sequences sets sorting ;
IN: rosetta-code.count-the-coins

<PRIVATE

:: (make-change) ( cents coins -- ways )
    cents 1 + 0 <array> :> ways
    1 ways set-first
    coins [| coin |
        coin cents [a,b] [| j |
            j coin - ways nth j ways [ + ] change-nth
        ] each
    ] each ways last ;

PRIVATE>

! How many ways can we make the given amount of cents
! with the given set of coins?
: make-change ( cents coins -- ways )
    members [ ] inv-sort-with (make-change) ;
