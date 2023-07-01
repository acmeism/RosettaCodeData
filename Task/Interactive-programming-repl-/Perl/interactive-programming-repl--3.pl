$ perl -lpe '$_=eval||$@'
sub f { join '' => @_[0, 2, 2, 1] }

f qw/Rosetta Code :/
Rosetta::Code
