#!/bin/awk -f
BEGIN {   	          # file modification time on Unix, using stat
   fn ="input.txt"

   cmd="stat " fn
   print "#", cmd
   system(cmd)            # just execute cmd

   cmd="stat -c %Y " fn   # seconds since the epoch
   print "#", cmd
   system(cmd)

   cmd="stat -c %y " fn   # human-readable format
   print "#", cmd
   system(cmd)

   print "##"
   cmd | getline x        # get output from cmd
  #print x
   close(cmd)

   n=split(x,stat," ")
  #for (i in stat) { print i, stat[i] }
   print "file:", fn
   print "date:", stat[1], "time:", stat[2]

### change filetime with touch:

   cmd="touch -t 201409082359.59 " fn
   print "#", cmd; system(cmd)

   cmd="stat " fn
   print "#", cmd; system(cmd)
}
