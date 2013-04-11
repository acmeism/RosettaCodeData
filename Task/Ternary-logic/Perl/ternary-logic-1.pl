package Trit;

# -1 = false ; 0 = maybe ; 1 = true

use Exporter 'import';

our @EXPORT_OK = qw(TRUE FALSE MAYBE is_true is_false is_maybe);
our %EXPORT_TAGS = (
	all => \@EXPORT_OK,
	const => [qw(TRUE FALSE MAYBE)],
	bool => [qw(is_true is_false is_maybe)],
);

use List::Util qw(min max);

use overload
'='  => sub { $_[0]->clone() },
'<=>'=> sub { $_[0]->cmp($_[1]) },
'cmp'=> sub { $_[0]->cmp($_[1]) },
'==' => sub { ${$_[0]} == ${$_[1]} },
'eq' => sub { $_[0]->equiv($_[1]) },
'>'  => sub { ${$_[0]} > ${$_[1]} },
'<'  => sub { ${$_[0]} < ${$_[1]} },
'>=' => sub { ${$_[0]} >= ${$_[1]} },
'<=' => sub { ${$_[0]} <= ${$_[1]} },
'|'  => sub { $_[0]->or($_[1]) },
'&'  => sub { $_[0]->and($_[1]) },
'!'  => sub { $_[0]->not() },
'~'  => sub { $_[0]->not() },
'""' => sub { $_[0]->tostr() },
'0+' => sub { $_[0]->tonum() },
;

sub new
{
	my ($class, $v) = @_;
	my $ret =
		!defined($v) ? 0 :
		$v eq 'true' ? 1 :
		$v eq 'false'? -1 :
		$v eq 'maybe'? 0 :
		$v > 0 ? 1 :
		$v < 0 ? -1 :
		0;
	return bless \$ret, $class;
}

sub TRUE()  { new Trit( 1) }
sub FALSE() { new Trit(-1) }
sub MAYBE() { new Trit( 0) }

sub clone
{
	my $ret = ${$_[0]};
	return bless \$ret, ref($_[0]);
}

sub tostr { ${$_[0]} > 0 ? "true" : ${$_[0]} < 0 ? "false" : "maybe" }
sub tonum { ${$_[0]} }

sub is_true { ${$_[0]} > 0 }
sub is_false { ${$_[0]} < 0 }
sub is_maybe { ${$_[0]} == 0 }

sub cmp { ${$_[0]} <=> ${$_[1]} }
sub not { new Trit(-${$_[0]}) }
sub and { new Trit(min(${$_[0]}, ${$_[1]}) ) }
sub or  { new Trit(max(${$_[0]}, ${$_[1]}) ) }

sub equiv { new Trit( ${$_[0]} * ${$_[1]} ) }
