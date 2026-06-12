# Copyright Shlomi Fish, 2013 under the MIT/X11 License.

use strict;
use warnings;

use Getopt::Long qw(GetOptions);
my $output_path;
my $verbose = '';
my $length = 24;

GetOptions(
    "length=i" => \$length,
    "output|o=s" => \$output_path,
    "verbose!" => \$verbose,
) or die ("Error in command line arguments");

print "Outputting to '", ($output_path // '(undefined)'), "' path, with ",
    ($verbose ? "Verbosity" : "No verbosity"),
    " and a length of $length.\n";
