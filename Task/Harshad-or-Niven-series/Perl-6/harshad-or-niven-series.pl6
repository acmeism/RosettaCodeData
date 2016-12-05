constant @harshad = grep { $_ %% .comb.sum }, 1 .. *;

say @harshad[^20];
say @harshad.first: * > 1000;
