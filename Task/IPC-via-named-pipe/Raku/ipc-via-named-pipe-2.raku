# use mkfifo directly from libc
use NativeCall;
sub mkfifo(Str $pathname, int32 $mode --> int32) is native('libc.so.6') is symbol('mkfifo') {*}

# create filenames and named pipes in TMP
my ($in, $out) = <in out>.map: -> $name { $*TMPDIR.add("$name-$*PID") };
   ($in, $out).map:            -> $name { mkfifo(Str($name), 0o666)   };

('In :: Out', "$in :: $out")>>.say;

my atomicint $char-count = 0;

my Supply $in-changed = $in.dirname.IO.watch.grep({ .path eq $in and
                                                    .event ~~ FileChanged });

react { whenever $in-changed {
               # calculate new char-count
               given $in.open(:r) {
                    .lock: :shared;
                    say $char-count ⚛+= .readchars.chomp.codes;
                    .close;
                }

                # write new char-count to $out
                given $out.open(:w) {
                    .lock;
                    .spurt: $char-count;
                    .close;
                }
        }
}
