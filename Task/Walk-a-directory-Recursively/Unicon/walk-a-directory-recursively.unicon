###########################
#  A sequential solution  #
###########################

procedure main()
every write(!getdirs("."))  # writes out all directories from the current directory down
end

procedure getdirs(s)  #: return a list of directories beneath the directory 's'
local D,d,f

if ( stat(s).mode ? ="d" ) & ( d := open(s) ) then {
      D := [s]
      while f := read(d) do
         if not ( ".." ? =f ) then          # skip . and ..
            D |||:= getdirs(s || "/" ||f)
      close(d)
      return D
      }
end

#########################
#  A threaded solution  #
#########################

import threads

global n,           # number of the concurrently running threads
       maxT,        # Max number of concurrent threads ("soft limit")
       tot_threads  # the total number of threads created in the program

procedure main(argv)
   target := argv[1] | stop("Usage: tdir [dir name] [#threads]. #threads default to 2* the number of cores in the machine.")
   tot_threads := n := 1
   maxT := ( integer(argv[2])|
	    (&features? if ="CPU cores " then cores := integer(tab(0)) * 2) | # available cores * 2
   	    4) # default to 4 threads
   t := milliseconds()
   L := getdirs(target)  # writes out all directories from the current directory down
   write((*\L)| 0, " directories in ", milliseconds() - t,
	           " ms using ", maxT, "-concurrent/", tot_threads, "-total threads" )
end

procedure getdirs(s)  # return a list of directories beneath the directory 's'
local D,d,f, thrd

if ( stat(s).mode ? ="d" ) & ( d := open(s) ) then {
      D := [s]
      while f := read(d) do
         if not ( ".." ? =f ) then          # skip . and ..
            if n>=maxT then # max thread count reached
               D |||:= getdirs(s || "/" ||f)
            else # spawn a new thread for this directory
	       {/thrd:=[]; n +:= 1; put(thrd, thread getdirs(s || "/" ||f))}

      close(d)

      if \thrd then{  # If I have threads, collect their results
         tot_threads +:= *thrd
         n -:= 1      # allow new threads to be spawned while I'm waiting/collecting results
	 every wait(th := !thrd) do { # wait for the thread to finish
	    n -:= 1
	    D |||:= <@th   # If the thread produced a result, it is going to be
	                   # stored in its "outbox", <@th in this case serves as
	                   # a deferred return since the thread was created by
			   # thread getdirs(s || "/" ||f)
	                   # this is similar to co-expression activation semantics
            }
         n +:= 1
         }
      return D
      }
end
