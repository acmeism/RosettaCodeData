USING: continuations kernel io io.streams.string locals unicode.categories ;
IN: rosetta.odd-word

<PRIVATE
! Save current continuation.
: savecc ( -- continuation/f )
    [ ] callcc1 ; inline

! Jump back to continuation, where savecc will return f.
: jump-back ( continuation -- )
    f swap continue-with ; inline
PRIVATE>

:: read-odd-word ( -- )
    f :> first-continuation!
    f :> last-continuation!
    f :> reverse!
    ! Read characters. Loop until end of stream.
    [ read1 dup ] [
        dup Letter? [
            ! This character is a letter.
            reverse [
                ! Odd word: Write letters in reverse order.
                last-continuation savecc dup [
                    last-continuation!
                    2drop       ! Drop letter and previous continuation.
                ] [
                    ! After jump: print letters in reverse.
                    drop                ! Drop f.
                    swap write1         ! Write letter.
                    jump-back           ! Follow chain of continuations.
                ] if
            ] [
                ! Even word: Write letters immediately.
                write1
            ] if
        ] [
            ! This character is punctuation.
            reverse [
                ! End odd word. Fix trampoline, follow chain of continuations
                ! (to print letters in reverse), then bounce off trampoline.
                savecc dup [
                    first-continuation!
                    last-continuation jump-back
                ] [ drop ] if
                write1                  ! Write punctuation.
                f reverse!              ! Begin even word.
            ] [
                write1                  ! Write punctuation.
                t reverse!              ! Begin odd word.
                ! Create trampoline to bounce to (future) first-continuation.
                savecc dup [
                    last-continuation!
                ] [ drop first-continuation jump-back ] if
            ] if
        ] if
    ] while
    ! Drop f from read1. Then print a cosmetic newline.
    drop nl ;

: odd-word ( string -- )
    [ read-odd-word ] with-string-reader ;
