use strict;
use warnings;
use feature 'say';
use Path::Tiny;

sub CopyPasta {
    my($code) = @_;
    my @code = split /\n/, $code =~ s/\s*\n+\s*/\n/gr;
    return "Program never ends!" unless grep { $_ eq 'Pasta!' } @code;

    my @cb;
    my $PC = 0;
    while (1) {
        if    ($code[$PC] eq 'Copy')      {        push @cb, $code[++$PC] }
        elsif ($code[$PC] eq 'CopyFile')  { $PC++; push @cb, join ' ', $code[$PC] eq 'TheF*ckingCode' ? @code : path($code[$PC])->slurp }
        elsif ($code[$PC] eq 'Duplicate') {             @cb = (@cb) x $code[++$PC] }
        elsif ($code[$PC] eq 'Pasta!')    { return @cb }
        else                              { return "Does not compute: $code[$PC]" }
        $PC++;
    }
}

path('pasta.txt')->spew( "I'm the pasta.txt file.");

for my $prog (
    "Copy \nRosetta Code\n\tDuplicate\n2\n\nPasta!\nLa Vista",
    "CopyFile\npasta.txt\nDuplicate\n1\nPasta!",
    "Copy\nInvalid\n Duplicate\n1\n\nGoto\n3\nPasta!",
    "CopyFile\nTheF*ckingCode\nDuplicate\n2\nPasta!",
    "Copy\nRosetta Code\nDuplicate\n2\n\nPasta"
) {
    say for CopyPasta($prog);
    say '';
}

unlink 'pasta.txt';
