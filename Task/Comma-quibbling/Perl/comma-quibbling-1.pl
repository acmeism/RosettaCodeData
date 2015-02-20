sub comma_quibbling(@) {
    return "{$_}" for
        @_ < 2 ? "@_" :
        join(', ', @_[0..@_-2]) . ' and ' . $_[-1];
}

print comma_quibbling(@$_), "\n" for
    [], [qw(ABC)], [qw(ABC DEF)], [qw(ABC DEF G H)];
