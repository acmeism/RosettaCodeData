use ntheory qw/forprimes znorder/;
my($t,$z)=(0,0);
forprimes {
  $z = znorder(10, $_);
  $t++ if defined $z && $z+1 == $_;
} 8192000;
print "$t\n";
