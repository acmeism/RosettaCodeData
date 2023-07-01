: task(n, jobs, myChannel)
   while(true) [
      System.Out "TASK " << n << " : Beginning my work..." << cr
      System sleep(1000 rand)
      System.Out "TASK " << n << " : Finish, sendind done and waiting for others..." << cr
      jobs send($jobDone) drop
      myChannel receive drop
      ] ;

: checkPoint(n, jobs, channels)
   while(true) [
      #[ jobs receive drop ] times(n)
      "CHECKPOINT : All jobs done, sending done to all tasks" println
      channels apply(#[ send($allDone) drop ])
      ] ;

: testCheckPoint(n)
| jobs channels i |
   ListBuffer init(n, #[ Channel new ]) dup freeze ->channels
   Channel new ->jobs

   #[ checkPoint(n, jobs, channels) ] &
   n loop: i [ #[ task(i, jobs, channels at(i)) ] & ] ;
