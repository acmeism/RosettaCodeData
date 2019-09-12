sub permutation {
	my ($perm,@set) = @_;
	print "$perm\n" || return unless (@set);
	permutation($perm.$set[$_],@set[0..$_-1],@set[$_+1..$#set]) foreach (0..$#set);
}
my @input = (qw/a b c d/);
permutation('',@input);
