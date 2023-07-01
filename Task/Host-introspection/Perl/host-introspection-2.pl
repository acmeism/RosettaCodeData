use 5.010;
use Config;
my ($size, $order, $end) = @Config{qw(uvsize byteorder)};
given ($order) {
    when (join '', sort split '') { $end = 'little' }
    when (join '', reverse sort split '') { $end = 'big' }
    default { $end = 'mixed' }
}
say "UV size: $size, byte order: $order ($end-endian)";
