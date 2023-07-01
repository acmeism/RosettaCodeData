my @f = map(sub { $_ * $_ }, 0 .. 9);   # @f is an array of subs
print $f[$_](), "\n" for (0 .. 8); # call and print all but last
