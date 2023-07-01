my $TotalWorkers = 3;
my $BatchToRun = 3;
my @TimeTaken = (5..15); # in seconds

my $batch_progress = 0;
my @batch_lock = map { Semaphore.new(1) } , ^$TotalWorkers;
my $lock = Lock.new;

sub assembly_line ($ID) {
   my $wait;
   for ^$BatchToRun -> $j {
      $wait = @TimeTaken.roll;
      say "Worker ",$ID," at batch $j will work for ",$wait," seconds ..";
      sleep($wait);
      $lock.protect: {
         my $k = ++$batch_progress;
         print "Worker ",$ID," is done and update batch $j complete counter ";
         say "to $k of $TotalWorkers";
         if ($batch_progress == $TotalWorkers) {
            say ">>>>> batch $j completed.";
            $batch_progress = 0; # reset for next batch
            for @batch_lock { .release }; # and ready for next batch
         };
       };

       @batch_lock[$ID].acquire; # for next batch
   }
}

for ^$TotalWorkers -> $i {
   Thread.start(
      sub {
         @batch_lock[$i].acquire;
         assembly_line($i);
      }
   );
}
