program BrownianTree
  use RCImageBasic
  use RCImageIO

  implicit none

  integer, parameter :: num_particles = 1000
  integer, parameter :: wsize         = 800

  integer, dimension(wsize, wsize) :: world
  type(rgbimage) :: gworld
  integer :: x, y

  ! init seed
  call init_random_seed

  world = 0
  call draw_brownian_tree(world)

  call alloc_img(gworld, wsize, wsize)
  call fill_img(gworld, rgb(0,0,0))

  do y = 1, wsize
     do x = 1, wsize
        if ( world(x, y) /= 0 ) then
           call put_pixel(gworld, x, y, rgb(255, 255, 255))
        end if
     end do
  end do

  open(unit=10, file='browniantree.ppm', action='write')
  call output_ppm(10, gworld)
  close(10)

  call free_img(gworld)

contains

  ! this code is taken from the GNU gfortran online doc
  subroutine init_random_seed
    integer :: i, n, clock
    integer, dimension(:), allocatable :: seed

    call random_seed(size = n)
    allocate(seed(n))
    call system_clock(count = clock)
    seed = clock + 37 * (/ ( i - 1, i = 1, n) /)
    call random_seed(put = seed)
    deallocate(seed)
  end subroutine init_random_seed


  function randbetween(a, b) result(res) ! suppose a < b
    integer, intent(in) :: a, b
    integer :: res

    real :: r

    call random_number(r)

    res = a + int((b-a)*r + 0.5)

  end function randbetween

  function bounded(v, ll, ul) result(res)
    integer, intent(in) :: v, ll, ul
    logical res

    res = ( v >= ll ) .and. ( v <= ul )
  end function bounded


  subroutine draw_brownian_tree(w)
    integer, dimension(:,:), intent(inout) :: w

    integer :: px, py, dx, dy, i
    integer :: xsize, ysize

    xsize = size(w, 1)
    ysize = size(w, 2)

    w(randbetween(1, xsize), randbetween(1, ysize)) = 1

    do i = 1, num_particles
       px = randbetween(1, xsize)
       py = randbetween(1, ysize)

       do
          dx = randbetween(-1, 1)
          dy = randbetween(-1, 1)
          if ( .not. bounded(dx+px, 1, xsize) .or. .not. bounded(dy+py, 1, ysize) ) then
             px = randbetween(1, xsize)
             py = randbetween(1, ysize)
          else if ( w(px+dx, py+dy) /= 0 ) then
             w(px, py) = 1
             exit
          else
             py = py + dy
             px = px + dx
          end if
       end do
    end do

  end subroutine draw_brownian_tree

end program
