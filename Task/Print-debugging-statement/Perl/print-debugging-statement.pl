use Carp;

$str = 'Resistance'; carp "'$str' is futile."; print "\n";

doodle($str); print "\n";

fiddle(7);

sub doodle { my ($str) = @_; carp "'$str' is still futile." }

sub fiddle { faddle(2*shift) }
sub faddle { fuddle(3*shift) }
sub fuddle { ( carp("'$_[0]', interesting number.") ); }
