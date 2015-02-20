use ntheory qw/divisor_sum/;
say join " ", map { divisor_sum($_)-$_ <=> $_ } 1..30;
