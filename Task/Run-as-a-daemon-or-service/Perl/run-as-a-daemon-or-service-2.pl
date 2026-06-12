use warnings;
use strict;

use Daemon::Control;

exit Daemon::Control->new(
   name       => 'Counter daemon',
   program    => '/home/hkdtam/count.pl',
   pid_file   => '/tmp/counter.pid',
)->run;
