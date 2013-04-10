module ForestFireModel
  implicit none

  type :: forestfire
     integer, dimension(:,:,:), allocatable :: field
     integer :: width, height
     integer :: swapu
     real :: prob_tree, prob_f, prob_p
  end type forestfire

  integer, parameter :: &
       empty = 0, &
       tree = 1, &
       burning = 2

  private :: bcheck, set, oget, burning_neighbor ! cset, get

contains

  ! create and initialize the field(s)
  function forestfire_new(w, h, pt, pf, pp) result(res)
    type(forestfire) :: res
    integer, intent(in) :: w, h
    real, intent(in), optional :: pt, pf, pp

    integer :: i, j
    real :: r

    allocate(res%field(2,w,h)) ! no error check
    res%prob_tree = 0.5
    res%prob_f = 0.00001
    res%prob_p = 0.001
    if ( present(pt) ) res%prob_tree = pt
    if ( present(pf) ) res%prob_f = pf
    if ( present(pp) ) res%prob_p = pp

    res%width = w
    res%height = h
    res%swapu = 0

    res%field = empty

    do i = 1,w
       do j = 1,h
          call random_number(r)
          if ( r <= res%prob_tree ) call cset(res, i, j, tree)
       end do
    end do

  end function forestfire_new

  ! destroy the field(s)
  subroutine forestfire_destroy(f)
    type(forestfire), intent(inout) :: f

    if ( allocated(f%field) ) deallocate(f%field)

  end subroutine forestfire_destroy

  ! evolution
  subroutine forestfire_evolve(f)
    type(forestfire), intent(inout) :: f

    integer :: i, j
    real :: r

    do i = 1, f%width
       do j = 1, f%height
          select case ( get(f, i, j) )
          case (burning)
             call set(f, i, j, empty)
          case (empty)
             call random_number(r)
             if ( r > f%prob_p ) then
                call set(f, i, j, empty)
             else
                call set(f, i, j, tree)
             end if
          case (tree)
             if ( burning_neighbor(f, i, j) ) then
                call set(f, i, j, burning)
             else
                call random_number(r)
                if ( r > f%prob_f ) then
                   call set(f, i, j, tree)
                else
                   call set(f, i, j, burning)
                end if
             end if
          end select
       end do
    end do
    f%swapu = ieor(f%swapu, 1)
  end subroutine forestfire_evolve

  ! helper funcs/subs
  subroutine set(f, i, j, t)
    type(forestfire), intent(inout) :: f
    integer, intent(in) :: i, j, t

    if ( bcheck(f, i, j) ) then
       f%field(ieor(f%swapu,1), i, j) = t
    end if
  end subroutine set

  subroutine cset(f, i, j, t)
    type(forestfire), intent(inout) :: f
    integer, intent(in) :: i, j, t

    if ( bcheck(f, i, j) ) then
       f%field(f%swapu, i, j) = t
    end if
  end subroutine cset

  function bcheck(f, i, j)
    logical :: bcheck
    type(forestfire), intent(in) :: f
    integer, intent(in) :: i, j

    bcheck = .false.
    if ( (i >= 1) .and. (i <= f%width) .and. &
         (j >= 1) .and. (j <= f%height) ) bcheck = .true.

  end function bcheck


  function get(f, i, j) result(r)
    integer :: r
    type(forestfire), intent(in) :: f
    integer, intent(in) :: i, j

    if ( .not. bcheck(f, i, j) ) then
       r = empty
    else
       r = f%field(f%swapu, i, j)
    end if
  end function get

  function oget(f, i, j) result(r)
    integer :: r
    type(forestfire), intent(in) :: f
    integer, intent(in) :: i, j

    if ( .not. bcheck(f, i, j) ) then
       r = empty
    else
       r = f%field(ieor(f%swapu,1), i, j)
    end if
  end function oget

  function burning_neighbor(f, i, j) result(r)
    logical :: r
    type(forestfire), intent(in) :: f
    integer, intent(in) :: i, j

    integer, dimension(3,3) :: s

    s = f%field(f%swapu, i-1:i+1, j-1:j+1)
    s(2,2) = empty
    r = any(s == burning)
  end function burning_neighbor

  subroutine forestfire_print(f)
    type(forestfire), intent(in) :: f

    integer :: i, j

    do j = 1, f%height
       do i = 1, f%width
          select case(get(f, i, j))
          case (empty)
             write(*,'(A)', advance='no') '.'
          case (tree)
             write(*,'(A)', advance='no') 'Y'
          case (burning)
             write(*,'(A)', advance='no') '*'
          end select
       end do
       write(*,*)
    end do
  end subroutine forestfire_print

end module ForestFireModel
