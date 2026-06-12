for 1..10 { next if $_ %% 2; say '_' x $_ };  # for next
map { next if $_ %% 2; say '_' x $_ }, 1..10; # equivalent map
