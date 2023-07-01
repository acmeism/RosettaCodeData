sub binomial { [*] ($^n … 0) Z/ 1 .. $^p }

my @bell = 1, -> *@s { [+] @s »*« @s.keys.map: { binomial(@s-1, $_) }  } … *;

.say for @bell[^15], @bell[50 - 1];
