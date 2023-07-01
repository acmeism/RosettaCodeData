package Set {
    sub new       { bless { map {$_ => undef} @_[1..$#_] }, shift; }
    sub elements  { sort keys %{shift()} }
    sub as_string { 'Set(' . join(' ', sort keys %{shift()}) . ')' }
    # ...more set methods could be defined here...
}
