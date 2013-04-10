package Elementwise;

use Exporter 'import';

use overload
'='  => sub { $_[0]->clone() },
'+'  => sub { $_[0]->add($_[1]) },
'-'  => sub { $_[0]->sub($_[1]) },
'*'  => sub { $_[0]->mul($_[1]) },
'/'  => sub { $_[0]->div($_[1]) },
'**'  => sub { $_[0]->exp($_[1]) },
;

sub new
{
	my ($class, $v) = @_;
	return bless $v, $class;
}

sub clone
{
	my @ret = @{$_[0]};
	return bless \@ret, ref($_[0]);
}

sub add { new Elementwise ref($_[1]) ? [map { $_[0][$_]  + $_[1][$_] } 0 .. $#{$_[0]} ] : [map { $_[0][$_]  + $_[1] } 0 .. $#{$_[0]} ] }
sub sub { new Elementwise ref($_[1]) ? [map { $_[0][$_]  - $_[1][$_] } 0 .. $#{$_[0]} ] : [map { $_[0][$_]  - $_[1] } 0 .. $#{$_[0]} ] }
sub mul { new Elementwise ref($_[1]) ? [map { $_[0][$_]  * $_[1][$_] } 0 .. $#{$_[0]} ] : [map { $_[0][$_]  * $_[1] } 0 .. $#{$_[0]} ] }
sub div { new Elementwise ref($_[1]) ? [map { $_[0][$_]  / $_[1][$_] } 0 .. $#{$_[0]} ] : [map { $_[0][$_]  / $_[1] } 0 .. $#{$_[0]} ] }
sub exp { new Elementwise ref($_[1]) ? [map { $_[0][$_] ** $_[1][$_] } 0 .. $#{$_[0]} ] : [map { $_[0][$_] ** $_[1] } 0 .. $#{$_[0]} ] }

1;
