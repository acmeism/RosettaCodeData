use Inline
    C => "DATA",
    ENABLE => "AUTOWRAP",
    LIBS => "-lm";

print 4*atan(1) . "\n";

__DATA__
__C__
double atan(double x);
