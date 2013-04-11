use Trit ':all';

my @a = (TRUE(), MAYBE(), FALSE());

print "\na\tNOT a\n";
print "$_\t".(!$_)."\n" for @a;	# Example of use of prefix operator NOT. Tilde ~ also can be used.


print "\nAND\t".join("\t",@a)."\n";
for my $a (@a) {
	print $a;
	for my $b (@a) {
		print "\t".($a & $b);	# Example of use of infix & (and)
	}
	print "\n";
}

print "\nOR\t".join("\t",@a)."\n";
for my $a (@a) {
	print $a;
	for my $b (@a) {
		print "\t".($a | $b);	# Example of use of infix | (or)
	}
	print "\n";
}

print "\nEQV\t".join("\t",@a)."\n";
for my $a (@a) {
	print $a;
	for my $b (@a) {
		print "\t".($a eq $b);	# Example of use of infix eq (equivalence)
	}
	print "\n";
}

print "\n==\t".join("\t",@a)."\n";
for my $a (@a) {
	print $a;
	for my $b (@a) {
		print "\t".($a == $b);	# Example of use of infix == (equality)
	}
	print "\n";
}
