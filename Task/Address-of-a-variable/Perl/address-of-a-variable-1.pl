use Scalar::Util qw(refaddr);
print refaddr(\my $v), "\n";  # 140502490125712
