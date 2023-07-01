map {
    my $squish = .comb.squish.join;
    printf "\nLength: %2d <<<%s>>>\nCollapsible: %s\nLength: %2d <<<%s>>>\n",
      .chars, $_, .chars != $squish.chars, $squish.chars, $squish
}, lines

q:to/STRINGS/;

    "If I were two-faced, would I be wearing this one?" --- Abraham Lincoln
    ..1111111111111111111111111111111111111111111111111111111111111117777888
    I never give 'em hell, I just tell the truth, and they think it's hell.
                                                        --- Harry S Truman
    The American people have a right to know if their president is a crook.
                                                        --- Richard Nixon
    AАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑ
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    STRINGS
