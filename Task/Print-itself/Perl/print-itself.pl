# 20201011 added Perl programming solution

use strict;
use warnings;

open my $in, '<', $0 or die;
print while <$in>;
close($in)

# @ARGV=$0; print <> # slurp without an explicit open()
