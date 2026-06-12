enum C0 (|(^32).map({ (0x2400 + $_).chr => $_ }), '␡' => 127);

printf "Ord: %3d, Unicode: %s, Enum: %s\n", $_, .uniname, C0($_)
   for (^128).grep: {.chr ~~ /<:Cc>/}
