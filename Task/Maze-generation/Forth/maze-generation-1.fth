\ Bit Arrays

: to-bits ( c -- f f f f f f f f )
    8 0 ?do
        2 /mod
        swap negate swap
    loop
    drop ;

: from-bits ( f f f f f f f f -- )
    8 0 ?do
        if [char] 1 emit else [char] 0 emit then
    loop ;

: byte-bin. ( c -- )
    to-bits from-bits space ;

: byte. ( c -- )
    dup byte-bin.
    dup 2 ['] u.r 16 base-execute space
    3 u.r space ;

: bytes-for-bits ( u1 -- u2 )
    8 /mod swap
    0> if 1+ then ;

: bits ( u -- bits )
    dup bytes-for-bits cell +  \ u-bits u-bytes
    dup allocate throw         \ u-bits u-bytes addr
    2dup swap erase nip        \ u-bits addr
    swap over ! ;              \ addr

: free-bits ( bits -- )
    free throw ;

: bits. ( bits -- )
    dup @ bytes-for-bits \ addr bytes
    swap cell+ swap      \ addr+cell bytes
    bounds ?do
        i cr 20 ['] u.r 16 base-execute space
        i c@ byte.
    loop
    cr ;

: bit-position ( u -- u-bit u-byte )
    8 /mod ;

: assert-bit ( bits u -- bits u )
    assert( 2dup swap @ < ) ;

: find-bit ( bits u1 -- addr u2 )
    assert-bit
    bit-position       \ addr bit byte
    rot                \ bit byte addr
    cell+ + swap ;     \ addr' bit

: set-true ( addr u -- )
    1 swap lshift over \ addr mask addr
    c@ or swap c! ;

: set-false ( addr u -- )
    1 swap lshift invert over \ addr mask addr
    c@ and swap c! ;

: set ( addr u f -- )
    if set-true else set-false then ;

: set-bit ( bits u f -- )
    { f }
    find-bit f set ;

: set-bits-at-addr ( addr u-start u-stop f -- )
    { f }
    1+ swap u+do
        dup i f set
    loop
    drop ;

: byte-from-flag ( f -- c )
    if 255 else 0 then ;

: set-bits { bits u-start u-stop f -- }

    u-start u-stop > if exit then

    bits u-start find-bit { addr-start bit-start }
    bits u-stop  find-bit { addr-stop  bit-stop  }

    addr-start addr-stop = if
        addr-start bit-start bit-stop f set-bits-at-addr
    else
        addr-start bit-start 7 f set-bits-at-addr
        addr-start 1+ addr-stop addr-start - 1- f byte-from-flag fill
        addr-stop 0 bit-stop f set-bits-at-addr
    then ;

: check-bit ( addr u -- f )
    find-bit           \ addr bit
    1 swap lshift swap \ mask addr
    c@ and 0> ;

: resize-bits ( bits u -- bits )
    over @ { old-size }
    tuck bytes-for-bits cell + resize throw \ u-bits bits
    2dup ! swap                             \ bits u-bits
    dup old-size > if
        over swap                           \ bits bits u-bits
        1- old-size swap false set-bits
    else
        drop
    then ;
