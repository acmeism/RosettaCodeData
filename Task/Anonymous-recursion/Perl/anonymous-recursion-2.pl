sub fib {
	my ($n) = @_;
	die "negative arg $n" if $n < 0;
	# put anon sub on stack and do a magic goto to it
	@_ = ($n, sub {
		my ($n, $f) = @_;
		# anon sub recurs with the sub ref on stack
		$n < 2 ? $n : $f->($n - 1, $f) + $f->($n - 2, $f)
	});
	goto $_[1];
}

print(fib($_), " ") for (0 .. 10);
