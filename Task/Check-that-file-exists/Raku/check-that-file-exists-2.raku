run ('touch', "♥ Unicode.txt");

say "♥ Unicode.txt".IO.e;      # "True"
say "♥ Unicode.txt".IO ~~ :e;  # same
