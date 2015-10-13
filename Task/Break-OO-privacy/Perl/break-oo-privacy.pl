package Foo;
sub new {
	my $class = shift;
	my $self = { _bar => 'I am ostensibly private' };
	return bless $self, $class;
}

sub get_bar {
	my $self = shift;
	return $self->{_bar};
}

package main;
my $foo = Foo->new();
print "$_\n" for $foo->get_bar(), $foo->{_bar};
