# Reference:
# https://github.com/hipek8/p6-UNIX-Daemonize/

use v6;
use UNIX::Daemonize;
use File::Temp;

my ($output, $filehandle) = tempfile(:tempdir("/tmp"),:!unlink) or die;

say "Output now goes to ",$output;

daemonize();

loop {
   sleep(1);
   spurt $output, DateTime.now.Str~"\n", :append;
}
