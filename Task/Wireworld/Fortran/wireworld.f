program Wireworld
  implicit none

  integer, parameter :: max_generations = 12
  integer :: nrows = 0, ncols = 0, maxcols = 0
  integer :: gen, ierr = 0
  integer :: i, j
  character(1), allocatable :: cells(:,:)
  character(10) :: form, sub
  character(80) :: buff

! open input file
  open(unit=8, file="wwinput.txt")

! find numbers of rows and columns in data
  do
    read(8, "(a)", iostat=ierr) buff
    if(ierr /= 0) exit
    nrows = nrows + 1
    ncols = len_trim(buff)
    if(ncols > maxcols) maxcols = ncols
  end do

! allcate enough space to hold the data
  allocate(cells(0:nrows+1, 0:maxcols+1))
  cells = " "

! load data
  rewind(8)
  do i = 1, nrows
    read(8, "(a)", iostat=ierr) buff
    if(ierr /= 0) exit
    do j = 1, maxcols
      cells(i, j) = buff(j:j)
    end do
  end do
  close(8)

! calculate format string for write statement
  write(sub, "(i8)") maxcols
  form = "(" // trim(adjustl(sub)) // "a1)"

  do gen = 0, max_generations
    write(*, "(/a, i0)") "Generation ", gen
    do i = 1, nrows
      write(*, form) cells(i, 1:maxcols)
    end do
    call nextgen(cells)
  end do
  deallocate(cells)

 contains

  subroutine Nextgen(cells)
    character, intent(in out) :: cells(0:,0:)
    character :: buffer(0:size(cells, 1)-1, 0:size(cells, 2)-1)
    integer :: i, j, h

     buffer = cells   ! Store current status
     do i = 1, size(cells, 1)-2
        do j = 1, size(cells, 2)-2
          select case (buffer(i, j))
            case(" ")
              ! no Change

            case("H")
              ! If a head change to tail
              cells(i, j) = "t"

            case("t")
              ! if a tail change to conductor
              cells(i, j) = "."

            case (".")
              ! Count number of electron heads in surrounding eight cells.
              ! We can ignore that fact that we count the centre cell as
              ! well because we already know it contains a conductor.
              ! If surrounded by 1 or 2 heads change to a head
              h = sum(count(buffer(i-1:i+1, j-1:j+1) == "H", 1))
              if(h == 1 .or. h == 2) cells(i, j) = "H"
          end select
        end do
     end do
  end subroutine Nextgen
end program Wireworld
