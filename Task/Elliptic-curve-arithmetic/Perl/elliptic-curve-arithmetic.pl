package EC;
{
    our ($A, $B) = (0, 7);
    package EC::Point;
    sub new { my $class = shift; bless [ @_ ], $class }
    sub zero { bless [], shift }
    sub x { shift->[0] }; sub y { shift->[1] };
    sub double {
        my $self = shift;
        return $self unless @$self;
        my $L = (3 * $self->x**2) / (2*$self->y);
        my $x = $L**2 - 2*$self->x;
        bless [ $x, $L * ($self->x - $x) - $self->y ], ref $self;
    }
    use overload
    '==' => sub { my ($p, $q) = @_; $p->x == $q->x and $p->y == $q->y },
    '+' => sub {
        my ($p, $q) = @_;
        return $p->double if $p == $q;
        return $p unless @$q;
        return $q unless @$p;
        my $slope = ($q->y - $p->y) / ($q->x - $p->x);
        my $x = $slope**2 - $p->x - $q->x;
        bless [ $x, $slope * ($p->x - $x)  - $p->y ], ref $p;
    },
    q{""} => sub {
        my $self = shift;
        return @$self
        ? sprintf "EC-point at x=%f, y=%f", @$self
        : 'EC point at infinite';
    }
}

package Test;
my $p = +EC::Point->new(-($EC::B - 1)**(1/3), 1);
my $q = +EC::Point->new(-($EC::B - 4)**(1/3), 2);
my $s = $p + $q, "\n";
print "$_\n" for $p, $q, $s;
print "check alignment... ";
print abs(($q->x - $p->x)*(-$s->y - $p->y) - ($q->y - $p->y)*($s->x - $p->x)) < 0.001
    ? "ok" : "wrong";
