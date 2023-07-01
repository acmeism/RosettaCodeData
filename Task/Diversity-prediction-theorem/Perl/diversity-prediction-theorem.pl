sub diversity {
    my($truth, @pred) = @_;
    my($ae,$ce,$cp,$pd,$stats);

    $cp += $_/@pred for @pred;      # collective prediction
    $ae = avg_error($truth, @pred); # average individual error
    $ce = ($cp - $truth)**2;        # collective error
    $pd = avg_error($cp, @pred);    # prediction diversity

    my $fmt = "%13s: %6.3f\n";
    $stats  = sprintf $fmt, 'average-error', $ae;
    $stats .= sprintf $fmt, 'crowd-error',   $ce;
    $stats .= sprintf $fmt, 'diversity',     $pd;
}

sub avg_error {
    my($m, @v) = @_;
    my($avg_err);
    $avg_err += ($_ - $m)**2 for @v;
    $avg_err/@v;
}

print diversity(49, qw<48 47 51>) . "\n";
print diversity(49, qw<48 47 51 42>);
