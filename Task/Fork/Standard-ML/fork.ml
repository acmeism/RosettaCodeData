case Posix.Process.fork () of
   SOME pid => print "This is the original process\n"
 | NONE     => print "This is the new process\n";
