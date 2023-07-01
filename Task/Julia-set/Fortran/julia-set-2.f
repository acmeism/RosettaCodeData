! ==============================================================================
module julia_mod
  ! ----------------------------------------------------------------------------
  implicit none

  character(*), parameter :: DEF_FSPC = 'julia.pgm'

  complex(8),   parameter :: DEF_SEED = (-0.798d0, 0.1618d0)

  complex(8),   parameter :: DEF_UL   = (-1.5d0,  1.0d0)
  complex(8),   parameter :: DEF_LR   = ( 1.5d0, -1.0d0)

  integer,      parameter :: NUM_COLS = 1024
  integer,      parameter :: NUM_ROWS =  768


contains


  ! ============================================================================
  subroutine juliaPGM( fspc, nr, nc, ul, lr, c )
    ! --------------------------------------------------------------------------
    implicit none
    character(*), intent(in) :: fspc ! path to the PGM file
    integer,      intent(in) :: nr   ! number of rows
    integer,      intent(in) :: nc   ! number of columns
    complex(8),   intent(in) :: ul   ! upper left  point on complex plane
    complex(8),   intent(in) :: lr   ! lower right point on complex plane
    complex(8),   intent(in) :: c    ! seed
    ! --------------------------------------------------------------------------
    real(8), allocatable :: X(:), Y(:)
    integer              :: un, ir, ic, i, clr
    complex(8)           :: z
    integer, parameter   :: max_cycle = 512
    ! --------------------------------------------------------------------------

    allocate( X(nc) )
    allocate( Y(nr) )

    call linSpace( X, ul%RE, lr%RE )
    call linSpace( Y, ul%IM, lr%IM )

    open ( FILE=fspc, NEWUNIT=un, ACTION='WRITE', STATUS='REPLACE' )

    write ( un, 100 )
    write ( un, 110 )
    write ( un, 120 ) nc, nr
    write ( un, 130 )

    do ir=1,nr
       do ic=1,nc
          z   = cmplx( X(ic), Y(ir), kind=8 )
          clr = 0
          i   = 0
          do while ( i .lt. max_cycle )
             z = z*z + c
             if ( 2.0D0 .lt. CDABS(z) ) then
                clr = modulo( i, 256 )
                exit
             end if
             i = i + 1
          end do
          write ( un, 200 ) clr
       end do
    end do

    close( un )

    deallocate( Y )
    deallocate( X )

100 format( 'P2' )
110 format( '# Created for Rosetta Code' )
120 format( I0,1X,I0 )
130 format( '255' )
200 format( I0 )

  end subroutine juliaPGM


  ! ============================================================================
  subroutine linSpace( A, a1, a2 )
    ! --------------------------------------------------------------------------
    implicit none
    real(8), intent(inout) :: A(:) ! array of the elements in this linear space
    real(8), intent(in)    :: a1   ! value of the first element
    real(8), intent(in)    :: a2   ! value of the last  element
    ! --------------------------------------------------------------------------
    integer :: i, n
    real(8) :: delta
    ! --------------------------------------------------------------------------

    n = size(A)

    delta = (a2-a1)/real(n-1,kind=8)
    A(1) = a1
    do i=2,n
       A(i) = A(i-1) + delta
    end do

  end subroutine linSpace


end module julia_mod


! ==============================================================================
program julia
  ! ----------------------------------------------------------------------------
  use julia_mod
  implicit none

  call juliaPGM( DEF_FSPC, NUM_ROWS, NUM_COLS, DEF_UL, DEF_LR, DEF_SEED )

end program julia
