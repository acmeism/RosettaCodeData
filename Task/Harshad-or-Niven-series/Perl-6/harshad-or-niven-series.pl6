constant @harshad = grep { $_ %% [+] .comb }, 1 .. *;

say @harshad[^20];
say @harshad.first: * > 1000;
