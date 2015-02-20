sub rms(*@nums) { sqrt [+](@nums X** 2) / @nums }

say rms 1..10;
