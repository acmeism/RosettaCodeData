use strict;
use 5.10.0;

package IO::File;
sub readline { CORE::readline(shift) } # icing, not essential

package Stream;
use Exporter 'import';

# Only overload one operator.  "file | stream" and "stream | stream"
# are not ambiguous like with shell commands.
use overload '|' => \&chain;
sub new {
	my $cls = shift;
	bless { args => [@_] }, ref $cls || $cls;
}

sub chain {
	my ($left, $right, $swap) = @_;
	($left, $right) = ($right, $left) if $swap;

	if (!ref $left) {
		my $h;
		open $h, $left and $left = $h or die $left
	}

	if (!ref $right) {
	# output file not implemented: don't know where I'd ever use it
		my $h;
		open $h, '>', $right	and $right = $h or die $right
	}

	if (ref $left and $left->isa(__PACKAGE__)) {
		$left->{output} = $right;
	}

	if (ref $right and $right->isa(__PACKAGE__)) {
		$right->{input} = $left;
	}
	$right;
}

# Read a line and do something to it.  By default it's this dummy
# pass-through function.  Overriding it defines a subclass' behavior
sub transform { shift; shift }

sub readline {
	my $obj = shift;
	my $line;
	return $line = <STDIN> unless defined $obj->{input};

	while (1) {
		$line = $obj->{input}->readline	or return;
		return $line if $line = $obj->transform($line);
	}
}

package Cat;
use parent -norequire, 'Stream';
# Dummy, exactly the same as Stream.  Except now we can invoke
# as Cat::ter, instead of Stream::ter, which is not even a word
sub ter { Cat->new(@_) }

package Grep;
use parent -norequire, 'Stream';

sub transform {
	my ($obj, $line) = @_;
	for (@{$obj->{args}}) {
		return $line if ($line =~ $_)
	}
	return;
}

sub per { Grep->new(@_) }

package Tee;
use parent -norequire, 'Stream';
sub er{
	my $obj = Tee->new(@_);
	@{$obj->{tees}} =
		map { open my $h, '>', $_ or die $_; $h }
		@{$obj->{args}};
	delete $obj->{args};
	$obj
}

sub transform {
	my ($obj, $line) = @_;
	print $_ $line for @{$obj->{tees}};
	$line;
}

package main;
my $chain =
	'/etc/services'		# head of chain; omit to use STDIN
	| Cat::ter		# don't really need this line
	| Grep::per(qr/tcp/)
	| Tee::er('/tmp/t1', '/tmp/t2')
	| Grep::per(qr/170/)
	| Tee::er('/tmp/t3')
	;

print while $_ = $chain->readline;
