my @harshad := gather for 1 .. * { take $_ if $_ %% [+] .comb }

say @harshad[^20];

say @harshad.first: * > 1000;
