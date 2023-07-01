use File::Find qw(find);
use File::Compare qw(compare);
use Sort::Naturally;
use Getopt::Std qw(getopts);

my %opts;
$opts{s} = 1;
getopts("s:", \%opts);

sub find_dups {
    my($dir) = @_;

    my @results;
    my %files;
    find {
        no_chdir => 1,
        wanted => sub { lstat; -f _ && (-s >= $opt{s} ) && push @{$files{-s _}}, $_ }
    } => $dir;

    foreach my $files (values %files) {
        next unless @$files;

        my %dups;
        foreach my $a (0 .. @$files - 1) {
            for (my $b = $a + 1 ; $b < @$files ; $b++) {
                next if compare(@$files[$a], @$files[$b]);
                push @{$dups{ @$files[$a] }}, splice @$files, $b--, 1;
            }
        }

        while (my ($original, $clones) = each %dups) {
            push @results, sprintf "%8d %s\n", (stat($original))[7], join ', ', sort $original, @$clones;
        }
    }
    reverse nsort @results;

}

print for find_dups(@ARGV);
