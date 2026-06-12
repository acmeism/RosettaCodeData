# 20230822 Raku programming solution

use OO::Monitors;

my \N = 10;

monitor Szymański {

   has @.tasks;
   my $critical = 0;

   method runSzymański($id) {
      @.tasks[$id] = 1;
      ( my @others = @.tasks ).splice: $id,1;
      until @others.all ~~ 0|1|2 { $*THREAD.yield }
      @.tasks[$id] = 3;
      if @others.any ~~ 1 {
         @.tasks[$id] = 2;
         until @others.any ~~ 4 { $*THREAD.yield }
      }
      @.tasks[$id] = 4;
      until @.tasks[^$id].all ~~ 0|1 { $*THREAD.yield }
      $critical = ((my $previous = $critical) + $id * 3) div 2;
      say "Thread $id changed the critical value from $previous to $critical";
      until @.tasks[$id^..*-1].all ~~ 0|1|4 { $*THREAD.yield }
      @.tasks[$id] = 0
   }
}

my $flag = Szymański.new: tasks => 0 xx N;
await Promise.allof( ^N .pick(*).map: { start { $flag.runSzymański: $_ } } );
