my $lock = Lock.new;

$lock.protect: { your-ad-here() }
