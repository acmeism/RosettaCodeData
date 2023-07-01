use strict;
use warnings;
use feature 'say';
use Heap::Priority;

my $h = Heap::Priority->new;

$h->highest_first(); # higher or lower number is more important
$h->add(@$_) for ["Clear drains",   3],
     ["Feed cat",     4],
     ["Make tea",     5],
     ["Solve RC tasks", 1],
     ["Tax return",     2];

say while ($_ = $h->pop);
