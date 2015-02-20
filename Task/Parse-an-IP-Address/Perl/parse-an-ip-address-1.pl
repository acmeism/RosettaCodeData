sub parse_v4 {
	my ($ip, $port) = @_;
	my @quad = split(/\./, $ip);

	return unless @quad == 4;
	for (@quad) { return if ($_ > 255) }

	if (!length $port) { $port = -1 }
	elsif ($port =~ /^(\d+)$/) { $port = $1 }
	else { return }

	my $h = join '' => map(sprintf("%02x", $_), @quad);
	return $h, $port
}

sub parse_v6 {
	my $ip = shift;
	my $omits;

	return unless $ip =~ /^[\da-f:.]+$/i; # invalid char

	$ip =~ s/^:/0:/;
	$omits = 1 if $ip =~ s/::/:z:/g;
	return if $ip =~ /z.*z/;	# multiple omits illegal

	my $v4 = '';
	my $len = 8;

	if ($ip =~ s/:((?:\d+\.){3}\d+)$//) {
		# hybrid 4/6 ip
		($v4) = parse_v4($1)	or return;
		$len -= 2;

	}
	# what's left should be v6 only
	return unless $ip =~ /^[:a-fz\d]+$/i;

	my @h = split(/:/, $ip);
	return if @h + $omits > $len;	# too many segments

	@h = map( $_ eq 'z' ? (0) x ($len - @h + 1) : ($_), @h);
	return join('' => map(sprintf("%04x", hex($_)), @h)).$v4;
}

sub parse_ip {
	my $str = shift;
	$str =~ s/^\s*//;
	$str =~ s/\s*$//;

	if ($str =~ s/^((?:\d+\.)+\d+)(?::(\d+))?$//) {
		return 'v4', parse_v4($1, $2);
	}

	my ($ip, $port);
	if ($str =~ /^\[(.*?)\]:(\d+)$/) {
		$port = $2;
		$ip = parse_v6($1);
	} else {
		$port = -1;
		$ip = parse_v6($str);
	}

	return unless $ip;
	return 'v6', $ip, $port;
}

for (qw/127.0.0.1 127.0.0.1:80
	::1
	[::1]:80
	2605:2700:0:3::4713:93e3
	[2605:2700:0:3::4713:93e3]:80
	::ffff:192.168.0.1
	[::ffff:192.168.0.1]:22
	::ffff:127.0.0.0.1
	a::b::1/)
{
	print "$_\n\t";
	my ($ver, $ip, $port) = parse_ip($_)
		or print "parse error\n" and next;

	print "$ver $ip\tport $port\n\n";
}
