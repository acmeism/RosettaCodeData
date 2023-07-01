sub population-count(Int $n where * >= 0) { [+] $n.base(2).comb }

say map &population-count, 3 «**« ^30;
say "Evil: ", (grep { population-count($_) %% 2 }, 0 .. *)[^30];
say "Odious: ", (grep { population-count($_)  % 2 }, 0 .. *)[^30];
