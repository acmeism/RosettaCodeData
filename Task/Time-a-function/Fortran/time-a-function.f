c The subroutine to analyze
      subroutine do_something()
c For testing we just do nothing for 3 seconds
      call sleep(3)
      return
      end

c Main Program
      program timing
      integer(kind=8) start,finish,rate,max
      call system_clock(start,rate,max)
c Here comes the function we want to time
      call do_something()
      call system_clock(finish,rate,max)
      write(6,*) 'Elapsed Time in seconds:',(finish-start)/rate
      return
      end
