    (1 x $_ ) !~ /^(11+)\1+$/  # test if prime
and $h = sprintf "%x", $_      # convert to hex
and $h eq reverse $h           # palindromic?
and print "$h "                # much rejoicing
    for 1..500;
