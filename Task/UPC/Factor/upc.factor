USING: combinators combinators.short-circuit formatting grouping
kernel locals math math.functions math.vectors sequences
sequences.repeating unicode ;

CONSTANT: numbers {
    "   ## #"
    "  ##  #"
    "  #  ##"
    " #### #"
    " #   ##"
    " ##   #"
    " # ####"
    " ### ##"
    " ## ###"
    "   # ##"
}

: upc>dec ( str -- seq )
    [ blank? ] trim 3 tail 3 head* 42 cut 5 tail
    [ 35 = 32 35 ? ] map append 7 group [ numbers index ] map ;

: valid-digits? ( seq -- ? ) [ f = ] none? ;

: valid-checksum? ( seq -- ? )
    { 3 1 } 12 cycle v* sum 10 divisor? ;

: valid-upc? ( seq -- ? )
    { [ valid-digits? ] [ valid-checksum? ] } 1&& ;

:: process-upc ( upc -- obj upside-down? )
    upc upc>dec :> d
    {
        { [ d valid-upc? ] [ d f ] }
        { [ upc reverse upc>dec dup valid-upc? ] [ t ] }
        { [ drop d valid-digits? ] [ "Invalid checksum" f ] }
        [ "Invalid digit(s)" f ]
    } cond ;

{
 "         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       "
  "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #      "
 "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #       "
   "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        "
 "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #       "
"          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #    "
 "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #     "
  "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #      "
 "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       "
  "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #      "
}
[ process-upc "(upside down)" "" ? "%u %s\n" printf ] each
