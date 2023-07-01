# 20211213 Perl programming solution

use strict;
use warnings;

use Class::Inspector;

print Class::Inspector->resolved_filename( 'IO::Socket::INET' ), "\n";
