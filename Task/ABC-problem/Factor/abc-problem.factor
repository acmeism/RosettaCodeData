USING: assocs combinators.short-circuit formatting grouping io
kernel math math.statistics qw sequences sets unicode ;
IN: rosetta-code.abc-problem

! === CONSTANTS ================================================

CONSTANT: blocks qw{
    BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM
}

CONSTANT: input qw{ A BARK BOOK TREAT COMMON SQUAD CONFUSE }

! === PROGRAM LOGIC ============================================

: pare ( str -- seq )
    [ blocks ] dip [ intersects? ] curry filter ;

: enough-blocks? ( str -- ? ) dup pare [ length ] bi@ <= ;

: enough-letters? ( str -- ? )
    [ blocks concat ] dip dup [ within ] dip
    [ histogram values ] bi@ [ - ] 2map [ neg? ] any? not ;

: can-make-word? ( str -- ? )
    >upper { [ enough-blocks? ] [ enough-letters? ] } 1&& ;

! === OUTPUT ===================================================

: show-blocks ( -- )
    "Available blocks:" print blocks [ 1 cut "(%s %s)" sprintf ]
    map 5 group [ [ write bl ] each nl ] each nl ;

: header ( -- )
    "Word" "Can make word from blocks?" "%-7s %s\n" printf
    "======= ==========================" print ;

: result ( str -- )
    dup can-make-word? "Yes" "No" ? "%-7s %s\n" printf ;

! === MAIN =====================================================

: abc-problem ( -- )
    show-blocks header input [ result ] each ;

MAIN: abc-problem
