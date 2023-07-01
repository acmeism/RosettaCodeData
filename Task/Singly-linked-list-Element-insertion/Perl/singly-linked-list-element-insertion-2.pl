sub insert_after {
  # first argument: node to insert after
  # second argument: node to insert
  $_[1]{next} = $_[0]{next};
  $_[0]{next} = $_[1];
}

my %B = (
    data => 3,
    next => undef, # not a circular list
);
my %A = (
    data => 1,
    next => \%B,
);
my %C = (
    data => 2,
);
insert_after \%A, \%C;
