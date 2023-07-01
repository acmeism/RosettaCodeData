use Devel::Size qw(size total_size);

my $var = 9384752;
my @arr = (1, 2, 3, 4, 5, 6);
print size($var);         # 24
print total_size(\@arr);  # 256
