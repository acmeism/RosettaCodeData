use v5.36;

package Resistor;
require Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw(set_voltage report);

use overload '+' => \&serial, '*' => \&parallel;

sub new ($class, $args) {
    my $self = {
        symbol     => $args->{symbol},
        voltage    => $args->{voltage},
        resistance => $args->{resistance},
        a          => $args->{a},
        b          => $args->{b},
    };
    return bless $self, $class;
}

sub res ($self) {
    if    ($self->{symbol} eq '+') { return res($self->{a}) + res($self->{b}) }
    elsif ($self->{symbol} eq '*') { return 1 / (1/res($self->{a}) + 1/res($self->{b})) }
    else                           { return $self->{resistance} }
}

sub set_voltage ($self,$voltage) {
    if ($self->{symbol} eq '+') {
        my $ra = res($self->{a});
        my $rb = res($self->{b});
        set_voltage($self->{a}, $ra / ($ra+$rb) * $voltage );
        set_voltage($self->{b}, $rb / ($ra+$rb) * $voltage );
    } elsif ($self->{symbol} eq '*') {
        set_voltage($self->{a}, $voltage );
        set_voltage($self->{b}, $voltage );
    }
    $self->{voltage} = $voltage;
}

sub current ($self) { return $self->{voltage} / res($self)     }
sub effect  ($self) { return $self->{voltage} * current($self) }

sub serial   ($a,$b,$) { Resistor->new( {symbol => '+', a => $a, b => $b} ) }
sub parallel ($a,$b,$) { Resistor->new( {symbol => '*', a => $a, b => $b} ) }

sub report ($self,$level = 0) {
    state @results;
    push @results, '      Ohm     Volt   Ampere     Watt   Network tree' and $level = 1 unless $level;
    my $pad = ('| ') x $level;
    my $f = sprintf '%9.3f' x 4, res($self), $self->{voltage}, current($self), effect($self);
    say "$f $pad" . $self->{symbol};
    report($self->{a}, $level+1) if defined $self->{a};
    report($self->{b}, $level+1) if defined $self->{b};
    join "\n", @results;
}

}

package main;
Resistor->import;

my ($R1, $R2, $R3, $R4, $R5, $R6, $R7, $R8, $R9, $R10) =
    map { Resistor->new( {symbol => 'r', resistance => $_} ) } <6 8 4 8 4 6 8 10 6 2>;

my $node = (((($R8 + $R10) * $R9 + $R7) * $R6 + $R5)
                           * $R4 + $R3) * $R2 + $R1;

set_voltage($node,18);
say report($node);
