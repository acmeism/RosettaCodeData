use strict;

package LockedHash;
use parent 'Tie::Hash';
use Carp;

sub TIEHASH {
	my $cls = shift;
	my %h = @_;
	bless \%h, ref $cls || $cls;
}

sub STORE {
	my ($self, $k, $v) = @_;
	croak "Can't add key $k" unless exists $self->{$k};
	$self->{$k} = $v;
}

sub FETCH {
	my ($self, $k) = @_;
	croak "No key $k" unless exists $self->{$k};
	$self->{$k};
}

sub DELETE {
	my ($self, $k) = @_;
	croak "No key $k" unless exists $self->{$k};
	$self->{$k} = 0;
}

sub CLEAR { } # ignored
sub EXISTS { exists shift->{+shift} }

sub FIRSTKEY {
	my $self = shift;
	keys %$self;
	each %$self;
}

sub NEXTKEY {
	my $self = shift;
	each %$self;
}

sub lock_hash :prototype(\%) {
	my $ref = shift;
	tie(%$ref, __PACKAGE__, %$ref);
}

1;

my %h = (a => 3, b => 4, c => 5);

# lock down %h
LockedHash::lock_hash(%h);

# show hash content and iteration
for (sort keys %h) { print "$_ => $h{$_}\n"; }

# try delete b
delete $h{b};
print "\nafter deleting b: b => $h{b}\n";

# change value of a
$h{a} = 100;
print "\na => $h{a}\n";

# add a new key x: will die
eval { $h{x} = 1 };
if ($@) { print "Operation error: $@" }
