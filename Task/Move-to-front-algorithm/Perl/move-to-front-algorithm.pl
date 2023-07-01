use strict;
use warnings;
sub encode {
	my ($str) = @_;
	my $table = join '', 'a' .. 'z';
	map {
		$table =~ s/(.*?)$_/$_$1/ or die;
		length($1);
	} split //, $str;
}

sub decode {
	my $table = join '', 'a' .. 'z';
	join "", map {
		$table =~ s/(.{$_})(.)/$2$1/ or die;
		$2;
	} @_;
}

for my $test ( qw(broood bananaaa hiphophiphop) ) {
	my @encoded = encode($test);
	print "$test: @encoded\n";
	my $decoded = decode(@encoded);
	print "in" x ( $decoded ne $test );
	print "correctly decoded to $decoded\n";
}
