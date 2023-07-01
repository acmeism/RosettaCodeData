my $fasta_example = <<'END_FASTA_EXAMPLE';
>Rosetta_Example_1
THERECANBENOSPACE
>Rosetta_Example_2
THERECANBESEVERAL
LINESBUTTHEYALLMUST
BECONCATENATED
END_FASTA_EXAMPLE

my $num_newlines = 0;
while ( < $fasta_example > ) {
	if (/\A\>(.*)/) {
		print "\n" x $num_newlines, $1, ': ';
	}
	else {
		$num_newlines = 1;
		print;
	}
}
