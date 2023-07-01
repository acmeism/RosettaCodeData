real :: start, stop
real :: result

! System clock value interpreted as floating point seconds
call cpu_time( start )

result = do_timed_work()

call cpu_time( stop )

print *, "elapsed time: ", stop - start
