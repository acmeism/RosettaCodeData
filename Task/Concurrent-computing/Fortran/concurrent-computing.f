program concurrency
  implicit none
  character(len=*), parameter :: str1 = 'Enjoy'
  character(len=*), parameter :: str2 = 'Rosetta'
  character(len=*), parameter :: str3 = 'Code'
  integer                     :: i
  real                        :: h
  real, parameter             :: one_third = 1.0e0/3
  real, parameter             :: two_thirds = 2.0e0/3

  interface
     integer function omp_get_thread_num
     end function omp_get_thread_num
  end interface
  interface
     integer function omp_get_num_threads
     end function omp_get_num_threads
  end interface

  ! Use OpenMP to create a team of threads
  !$omp parallel do private(i,h)
  do i=1,20
     ! First time through the master thread output the number of threads
     ! in the team
     if (omp_get_thread_num() == 0 .and. i == 1) then
        write(*,'(a,i0,a)') 'Using ',omp_get_num_threads(),' threads'
     end if

     ! Randomize the order
     call random_number(h)

     !$omp critical
     if (h < one_third) then
        write(*,'(a)') str1
     else if (h < two_thirds) then
        write(*,'(a)') str2
     else
        write(*,'(a)') str3
     end if
     !$omp end critical
  end do
  !$omp end parallel do

end program concurrency
