integer :: start, stop, rate
real :: result

! optional 1st integer argument (COUNT) is current raw system clock counter value (not UNIX epoch millis!!)
! optional 2nd integer argument (COUNT_RATE) is clock cycles per second
! optional 3rd integer argument (COUNT_MAX) is maximum clock counter value
call system_clock( start, rate )

result = do_timed_work()

call system_clock( stop )

print *, "elapsed time: ", real(stop - start) / real(rate)
