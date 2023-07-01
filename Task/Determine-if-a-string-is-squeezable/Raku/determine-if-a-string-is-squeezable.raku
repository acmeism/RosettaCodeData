map {
    my $squeeze = $^phrase;
    sink $^reg;
    $squeeze ~~ s:g/($reg)$0+/$0/;
    printf "\nOriginal length: %d <<<%s>>>\nSqueezable on \"%s\": %s\nSqueezed length: %d <<<%s>>>\n",
      $phrase.chars, $phrase, $reg.uniname, $phrase ne $squeeze, $squeeze.chars, $squeeze
},
  '', ' ',
  '"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln ', '-',
  '..1111111111111111111111111111111111111111111111111111111111111117777888', '7',
  "I never give 'em hell, I just tell the truth, and they think it's hell. ", '.',
  '                                                    --- Harry S Truman  ', ' ',
  '                                                    --- Harry S Truman  ', '-',
  '                                                    --- Harry S Truman  ', 'r'
