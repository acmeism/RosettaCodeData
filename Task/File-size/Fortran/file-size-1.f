    use :: iso_fortran_env, only : FILE_STORAGE_SIZE
    implicit none
    character(len=*),parameter :: filename(*)=[character(len=256) :: 'input.txt', '/input.txt']
    integer                    :: file_size, i
    do i=1,size(filename)
       INQUIRE(FILE=filename(i), SIZE=file_size)  ! return -1 if cannot determine file size
       write(*,*)'size of file '//trim(filename(i))//' is ',file_size * FILE_STORAGE_SIZE /8,' bytes'
    enddo
    end
