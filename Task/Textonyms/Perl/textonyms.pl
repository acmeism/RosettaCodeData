sub find {
	my @m = qw/$ $ abc def ghi jkl mno pqrs tvu wxyz/;
	(my $r = shift) =~ s{(\d)}{[$m[$1]]}g;
	grep /^$r$/i, split ' ', `cat words.txt`; # cats don't run on windows
}

print join("\n", $_, find($_)), "\n\n" for @ARGV
