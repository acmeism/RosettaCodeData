use strict;
use warnings;
use feature 'say';

sub decode_UPC {
    my($line) = @_;
    my(%pattern_to_digit_1,%pattern_to_digit_2,@patterns1,@patterns2,@digits,$sum);

    for my $p ('   ## #', '  ##  #', '  #  ##', ' #### #', ' #   ##', ' ##   #', ' # ####', ' ### ##', ' ## ###', '   # ##') {
        push @patterns1, $p;
        push @patterns2, $p =~ tr/# / #/r;
    }

    $pattern_to_digit_1{$patterns1[$_]} = $_ for 0..$#patterns1;
    $pattern_to_digit_2{$patterns2[$_]} = $_ for 0..$#patterns2;

     my $re = '\s*# #\s*' .
              "(?<match1>(?:@{[join '|', @patterns1]}){6})" .
              '\s*# #\s*' .
              "(?<match2>(?:@{[join '|', @patterns2]}){6})" .
              '\s*# #\s*';
     $line =~ /^$re$/g || return;

    my($match1,$match2) = ($+{match1}, $+{match2});
    push @digits, $pattern_to_digit_1{$_} for $match1 =~ /(.{7})/g;
    push @digits, $pattern_to_digit_2{$_} for $match2 =~ /(.{7})/g;
    $sum += (3,1)[$_%2] * $digits[$_] for 0..11;
    $sum % 10 ? '' : join '', @digits;
}

my @lines = (
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
);

for my $line (@lines) {
    say decode_UPC($line)
     // decode_UPC(join '', reverse split '', $line)
     // 'Invalid';
}
