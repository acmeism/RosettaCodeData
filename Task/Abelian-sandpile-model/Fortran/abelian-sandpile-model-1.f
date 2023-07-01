module abelian_sandpile_m

  implicit none

  private
  public :: pile

  type :: pile
    !! usage:
    !!    1) init
    !!    2) run

    integer, allocatable :: grid(:,:)
    integer              :: n(2)

  contains
    procedure :: init
    procedure :: run

    procedure, private :: process_node
    procedure, private :: inside
  end type

contains

  logical function inside(this, i)
    class(pile), intent(in) :: this
    integer,     intent(in) :: i(2)

    inside = ((i(1) > 0) .and. (i(1) <= this%n(1)) .and. (i(2) > 0) .and. (i(2) <= this%n(2)) )
  end function

  recursive subroutine process_node(this, i)
    !! start process

    class(pile), intent(inout) :: this
    integer,     intent(in)    :: i(2)
      !! node coordinates to process

    integer :: i0(2,2), j(2), d, k

    ! if node has more than 4 grains -> redistribute
    if (this%grid(i(1),i(2)) >= 4) then
      ! unit vectors: help shift only one dimension (see below)
      i0 = reshape([1,0,0,1], [2,2])

      ! subtract 4 grains
      this%grid(i(1),i(2)) = this%grid(i(1),i(2))-4

      ! add one grain to neighbor if not out of bound
      do d = 1, 2               ! loop dimensions
        do k = -1, 1, 2         ! loop +-1 step in direction d
          j = i+k*i0(:,d)       ! j = i, but one element is shifted by +-1
          if (this%inside(j)) this%grid(j(1),j(2)) = this%grid(j(1),j(2)) + 1
        end do
      end do

      ! check neighbor nodes
      do d = 1, 2               ! loop dimensions
        do k = -1, 1, 2         ! loop +-1 step in direction d
          j = i+k*i0(:,d)       ! j = i, but one element is shifted by +-1
          if (this%inside(j)) call this%process_node(j)
        end do
      end do

      ! check itself
      call this%process_node(i)
    end if
  end subroutine

  subroutine run(this)
    !! start process

    class(pile), intent(inout) :: this

    ! only node that could be unstable is inital node
    call this%process_node(this%n/2)
  end subroutine

  subroutine init(this, nx, ny, h)
    class(pile), intent(out) :: this
    integer,     intent(in)  :: nx, ny
      !! grid dimensions
    integer,     intent(in)  :: h
      !! height of and grains in middle of grid

    this%n = [nx, ny]
    allocate (this%grid(nx,ny), source=0)
    this%grid(nx/2, ny/2) = h
  end subroutine

end module
