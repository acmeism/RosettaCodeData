my @list = qw(9 8 7 6 5 0 1 2 3 4);
print join ' ', map { qselect(\@list, $_) } 1 .. 10 and print "\n";

sub qselect
{
    my ($list, $k) = @_;
    my $pivot = @$list[int rand @{ $list } - 1];
    my @left  = grep { $_ < $pivot } @$list;
    my @right = grep { $_ > $pivot } @$list;
    if ($k <= @left)
    {
        return qselect(\@left, $k);
    }
    elsif ($k > @left + 1)
    {
        return qselect(\@right, $k - @left - 1);
    }
    else { $pivot }
}
