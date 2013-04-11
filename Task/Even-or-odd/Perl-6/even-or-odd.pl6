subset Even of Int where * %% 2;
subset Odd of Int where * % 2;

say 1 ~~ Even; # false
say 1 ~~ Odd;  # true
say 1.5 ~~ Odd # false ( 1.5 is not an Int )
