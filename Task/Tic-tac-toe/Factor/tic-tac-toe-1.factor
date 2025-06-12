USING: multiline math.vectors arrays sequences io.streams.c kernel assocs math io grouping math.matrices math.parser random strings ; IN: tictactoe

CONSTANT: winmasks { 7 56 448 73 146 292 273 84 }
t 0 0                                                                              ! turn board1 board2
[
  pick                                                                             ! turn b1 b2 turn
  [ 2dup bitor 9 <bits> f swap indices random set-bit ]                            ! cpu's move
  [ [ 2dup bitor nl "enter a move (1-9):" print readln string>number 1 - tuck      ! your move
      [ nip [ 9 < ] [ 0 >= ] bi and ] [ bit? not ] 2bi and [ set-bit f ] [ drop "no" print t ] if
    ] loop
  ] if    ! switch on turn
  { { [ dup winmasks swap [ bitand bit-count 3 = ] curry any?                      ! check for win
      ] [ pick "O" "X" ? " wins" append print f ]
    }
    { [ 2dup bitor 511 =  ] [ "tie" print f ]                                      ! check for tie
    } [ t ]                                                                        ! if neither, then loop
  } cond
  [ 3dup rot not [ swap ] when [ 9 <binary-bits> >array ] bi@ 2 v*n v+ 3 <groups>  ! display the board
    [ nl [ ".XO" nth 1string " " append write ] each ] each nl
  ] dip                                                                   ! keep loop flag
  [ not ] 3dip swapd                                                      ! negate turn; swap boards
] loop 3drop                                                              ! empty the stack when done
