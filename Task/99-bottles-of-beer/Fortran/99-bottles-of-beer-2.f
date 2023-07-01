program bottlesMPI

  implicit none

  integer :: ierr,rank,nproc

  character(len=*), parameter   :: bwall = " on the wall", &
                                   bottles = "bottles of beer", &
                                   bottle  = "bottle of beer", &
                                   take = "Take one down, pass it around", &
                                   form = "(I0, ' ', A)"

  call mpi_init(ierr)
  call mpi_comm_size(MPI_COMM_WORLD,nproc, ierr)
  call mpi_comm_rank(MPI_COMM_WORLD,rank,ierr)

  if ( rank /= 1 ) then
     write (*,form)  rank, bottles // bwall
     if ( rank > 0 ) write (*,form)  rank, bottles
  else
     write (*,form)  rank, bottle // bwall
     write (*,form)  rank, bottle
  end if
  if ( rank > 0 ) write (*,*) take

  call mpi_finalize(ierr)

end program bottlesMPI
