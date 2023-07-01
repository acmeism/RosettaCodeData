program sleepSort
    use omp_lib
    implicit none
    integer::nArgs,myid,i,stat
    integer,allocatable::intArg(:)
    character(len=5)::arg

    !$omp master
    nArgs=command_argument_count()
    if(nArgs==0)stop ' : No argument is given !'
    allocate(intArg(nArgs))
    do i=1,nArgs
        call get_command_argument(i, arg)
	read(arg,'(I5)',iostat=stat)intArg(i)
	if(intArg(i)<0 .or. stat/=0) stop&
        &' :Only 0 or positive integer allowed !'
    end do
    call omp_set_num_threads(nArgs)
    !$omp end master


    !$omp parallel private(myid)
    myid =omp_get_thread_num()
    call sleepNprint(intArg(myid+1))
    !$omp end parallel

  contains
	subroutine sleepNprint(nSeconds)
	    integer::nSeconds
            call sleep(nSeconds)
	    print*,nSeconds
	end subroutine sleepNprint
end program sleepSort
