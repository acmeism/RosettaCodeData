# 20241230 Raku programming solution

my $soundfile = "notes.wav";
my $repetitions;

if @*ARGS.elems < 1 {
   say "Usage: give number of repetitions in echo effect as argument to the program."
} else {
   given $*KERNEL.cpu-cores { $repetitions = @*ARGS[0] < $_ ?? @*ARGS[0] !! $_ }
}

for 0.0, 0.1 ... (($repetitions - 1) * 0.1) -> $seconds {
   sleep $seconds;
   my $proc = Proc::Async.new('play', '--no-show-progress', $soundfile);
   $proc.start
}
