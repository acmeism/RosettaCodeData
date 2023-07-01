length '' . @array; # 1
length      @array; # 1

print '0.', scalar @array, 'e', length @array, "\n"; # 0.5e1

@array = 1..123;
print '0.', scalar @array, 'e', length @array, "\n"; # 0.123e3

print 'the length of @array is on the order of ';
print 10 ** (length( @array )-1); # 100
print " elements long\n";
