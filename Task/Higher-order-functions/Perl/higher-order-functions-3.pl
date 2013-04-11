sub first {shift->()}

sub second {'second'}

print first \&second;

print first sub{'sub'};
