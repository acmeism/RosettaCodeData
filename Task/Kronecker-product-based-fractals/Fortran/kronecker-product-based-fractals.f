program Kron_frac
  implicit none

  interface
    function matkronpow(M, n) result(Mpowern)
      integer, dimension(:,:), intent(in) :: M
      integer, intent(in) :: n
      integer, dimension(size(M, 1)**n, size(M,2)**n) :: Mpowern
    end function matkronpow

    function kron(A, B) result(M)
      integer, dimension(:,:), intent(in) :: A, B
      integer, dimension(size(A,1)*size(B,1), size(A,2)*size(B,2)) :: M
    end function kron

    subroutine write2file(M, filename)
      integer, dimension(:,:), intent(in) :: M
      character(*), intent(in) :: filename
    end subroutine write2file
  end interface

  integer, parameter :: n = 4
  integer, dimension(3,3) :: Vicsek, Sierpinski
  integer, dimension(4,4) :: Hadamard
  integer, dimension(3**n, 3**n) :: fracV, fracS
  integer, dimension(4**n, 4**n) :: fracH

  Vicsek = reshape( (/0, 1, 0,&
                      1, 1, 1,&
                      0, 1, 0/),&
                    (/3,3/) )

  Sierpinski = reshape( (/1, 1, 1,&
                          1, 0, 1,&
                          1, 1, 1/),&
                          (/3,3/) )

  Hadamard = transpose(reshape( (/ 1, 0, 1, 0,&
                         1, 0, 0, 1,&
                         1, 1, 0, 0,&
                         1, 1, 1, 1/),&
                         (/4,4/) ))

  fracV = matkronpow(Vicsek, n)
  fracS = matkronpow(Sierpinski, n)
  fracH = matkronpow(Hadamard, n)

  call write2file(fracV, 'Viczek.txt')
  call write2file(fracS, 'Sierpinski.txt')
  call write2file(fracH, 'Hadamard.txt')

end program

function matkronpow(M, n) result(Mpowern)
interface
function kron(A, B) result(M)
  integer, dimension(:,:), intent(in) :: A, B
  integer, dimension(size(A,1)*size(B,1), size(A,2)*size(B,2)) :: M
  end function kron
end interface

  integer, dimension(:,:), intent(in) :: M
  integer, intent(in) :: n
  integer, dimension(size(M, 1)**n, size(M,2)**n) :: Mpowern
  integer, dimension(:,:), allocatable :: work1, work2
  integer :: icount

  if (n <= 1) then
     Mpowern = M
  else
    allocate(work1(size(M,1), size(M,2)))
    work1 = M
    do icount = 2,n
      allocate(work2(size(M,1)**icount, size(M,2)**icount))
      work2 = kron(work1, M)
      deallocate(work1)
      allocate(work1(size(M,1)**icount, size(M,2)**icount))
      work1 = work2
      deallocate(work2)
    end do
    Mpowern = work1
    deallocate(work1)
  end if

end function matkronpow

function kron(A, B) result(M)
  integer, dimension(:,:), intent(in) :: A, B
  integer, dimension(size(A,1)*size(B,1), size(A,2)*size(B,2)) :: M
  integer :: ia, ja, ib, jb, im, jm

  do ja = 1, size(A, 2)
    do ia = 1, size(A, 1)
      do jb = 1, size(B, 2)
        do ib = 1, size(B, 1)
          im = (ia - 1)*size(B, 1) + ib
          jm = (ja - 1)*size(B, 2) + jb
          M(im, jm) = A(ia, ja) * B(ib, jb)
        end do
      end do
    end do
  end do

end function kron

subroutine write2file(M, filename)
  integer, dimension(:,:), intent(in) :: M
  character(*), intent(in) :: filename
  integer :: ii, jj
  integer, parameter :: fi = 10

  open(fi, file=filename, status='replace')

  do ii = 1,size(M, 1)
    do jj = 1,size(M,2)
      if (M(ii,jj) == 0) then
        write(fi, '(A)', advance='no') ' '
      else
        write(fi, '(A)', advance='no') '*'
      end if
    end do
    write(fi, '(A)') ' '
  end do

  close(fi)

end subroutine write2file
