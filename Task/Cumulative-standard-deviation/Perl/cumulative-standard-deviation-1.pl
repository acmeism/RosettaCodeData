{
    package SDAccum;
    sub new {
	my $class = shift;
	my $self = {};
	$self->{sum} = 0.0;
	$self->{sum2} = 0.0;
	$self->{num} = 0;
	bless $self, $class;
	return $self;
    }
    sub count {
	my $self = shift;
	return $self->{num};
    }
    sub mean {
	my $self = shift;
	return ($self->{num}>0) ? $self->{sum}/$self->{num} : 0.0;
    }
    sub variance {
	my $self = shift;
	my $m = $self->mean;
	return ($self->{num}>0) ? $self->{sum2}/$self->{num} - $m * $m : 0.0;
    }
    sub stddev {
	my $self = shift;
	return sqrt($self->variance);
    }
    sub value {
	my $self = shift;
	my $v = shift;
	$self->{sum} += $v;
	$self->{sum2} += $v * $v;
	$self->{num}++;
	return $self->stddev;
    }
}
