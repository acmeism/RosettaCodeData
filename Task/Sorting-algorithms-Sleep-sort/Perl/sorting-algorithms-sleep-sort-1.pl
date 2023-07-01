1 while ($_ = shift and @ARGV and !fork);
sleep $_;
print "$_\n";
wait;
