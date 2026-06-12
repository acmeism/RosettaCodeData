# 20200923 Added Raku programming solution

use NativeCall;
use UUID; # cannot mix File::Temp with mkfifo well so use this as tmpnam

my ($in, $out) = <in out>.map: { "/tmp/$_-" ~ UUID.new } ;

sub mkfifo(Str $pathname, int32 $mode --> int32) is native('libc.so.6') is symbol('mkfifo') {*}

($in,$out).map: { die $!.message if mkfifo($_, 0o666) } ; # c style exit code

say "In  pipe: ", $in;
say "Out pipe: ", $out;

my atomicint $CharCount = 0;

signal(SIGINT).tap: {
   ($in,$out).map: { .IO.unlink or die } ;
   say "\nBye." and exit;
}

loop {
   given $in.IO.watch { # always true even when nothing is spinning ?

      say "Current count: ", $CharCount  ⚛+= $in.IO.open.readchars.codes;

      given $out.IO.open(:update :truncate) { # both truncate and flush aren't
         .flush or die ;                      # working on pipes so without a
         .spurt: "$CharCount\t"               # prior consumer it just appends
      }
      $out.IO.open.close or die;
   }
   sleep ½;
}
