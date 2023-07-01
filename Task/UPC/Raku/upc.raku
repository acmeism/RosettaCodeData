sub decode_UPC ( Str $line ) {
    constant @patterns1 = '   ## #', '  ##  #', '  #  ##', ' #### #', ' #   ##',
                          ' ##   #', ' # ####', ' ### ##', ' ## ###', '   # ##';
    constant @patterns2 = @patterns1».trans( '#' => ' ', ' ' => '#' );

    constant %pattern_to_digit_1 = @patterns1.antipairs;
    constant %pattern_to_digit_2 = @patterns2.antipairs;

    constant $re = / ^  '# #'  (@patterns1) ** 6
                       ' # # ' (@patterns2) ** 6
                        '# #'                     $ /;

    $line.trim ~~ $re
        orelse return;

    my @digits = flat %pattern_to_digit_1{ $0».Str },
                      %pattern_to_digit_2{ $1».Str };

    return unless ( @digits Z* ( |(3,1) xx * ) ).sum %% 10;

    return @digits.join;
}

my @lines =
    '         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ',
     '        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #      ',
    '         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #       ',
      '       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        ',
    '         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #       ',
   '          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #    ',
    '         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #     ',
     '        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #      ',
    '         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       ',
     '        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #      ',
;
for @lines -> $line {
    say decode_UPC($line)
     // decode_UPC($line.flip)
     // 'Invalid';
}
