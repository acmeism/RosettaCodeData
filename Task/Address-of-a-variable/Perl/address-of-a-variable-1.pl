use Scalar::Util qw(refaddr);
print refaddr(\my $v), "\n";  # 135691508
