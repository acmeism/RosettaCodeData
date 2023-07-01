my @animals = (
	"fly",
	"spider/That wriggled and jiggled and tickled inside her.\n",
	"bird//Quite absurd!",
	"cat//Fancy that!",
	"dog//What a hog!",
	"pig//Her mouth was so big!",
	"goat//She just opened her throat!",
	"cow//I don't know how;",
	"donkey//It was rather wonkey!",
	"horse:",
);

my $s = "swallow";
my $e = $s."ed";
my $t = "There was an old lady who $e a ";
my $_ = $t."But I don't know why she $e the fly;\nPerhaps she'll die!\n\n";

my ($a, $b, $c, $d);
while (my $x = shift @animals) {
	s/$c//;
	($a, $b, $c) = split('/', $x);
	$d = " the $a";

	$c =~ s/;/ she $e$d;\n/;
	$c =~ s/!/, to $s$d;\n/;

	s/$t/"$t$a,\n$c".(($b||$c) && "${b}She $e$d to catch the ")/e;

	s/:.*/--\nShe's dead, of course!\n/s;
	print;
}
