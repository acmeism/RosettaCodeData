module simanneal_support
  implicit none

  !
  ! The following two integer kinds are meant to be treated as
  ! synonyms.
  !
  ! selected_int_kind (2) = integers in the range of at least -100 to
  ! +100.
  !
  integer, parameter :: city_location_kind = selected_int_kind (2)
  integer, parameter :: path_index_kind = city_location_kind

  !
  ! selected_int_kind (1) = integers in the range of at least -10 to
  ! +10.
  !
  integer, parameter :: coordinate_kind = selected_int_kind(1)

  !
  ! selected_real_kind (6) = floating point with at least 6 decimal
  ! digits of precision.
  !
  integer, parameter :: float_kind = selected_real_kind (6)

  !
  ! Shorthand notations.
  !
  integer, parameter :: clk = city_location_kind
  integer, parameter :: pik = path_index_kind
  integer, parameter :: cok = coordinate_kind
  integer, parameter :: flk = float_kind

  type path_vector
     integer(kind = clk) :: elem(0:99)
  end type path_vector

contains

  function random_integer (imin, imax) result (n)
    integer, intent(in) :: imin, imax
    integer :: n

    real(kind = flk) :: randnum

    call random_number (randnum)
    n = imin + floor ((imax - imin + 1) * randnum)
  end function random_integer

  function i_coord (loc) result (i)
    integer(kind = clk), intent(in) :: loc
    integer(kind = cok) :: i

    i = loc / 10_clk
  end function i_coord

  function j_coord (loc) result (j)
    integer(kind = clk), intent(in) :: loc
    integer(kind = cok) :: j

    j = mod (loc, 10_clk)
  end function j_coord

  function location (i, j) result (loc)
    integer(kind = cok), intent(in) :: i, j
    integer(kind = clk) :: loc

    loc = (10_clk * i) + j
  end function location

  subroutine randomize_path_vector (path)
    type(path_vector), intent(out) :: path

    integer(kind = pik) :: i, j
    integer(kind = clk) :: xi, xj

    do i = 0_pik, 99_pik
       path%elem(i) = i
    end do

    ! Do a Fisher-Yates shuffle of elements 1 .. 99.
    do i = 1_pik, 98_pik
       j = int (random_integer (i + 1, 99), kind = pik)
       xi = path%elem(i)
       xj = path%elem(j)
       path%elem(i) = xj
       path%elem(j) = xi
    end do
  end subroutine randomize_path_vector

  function distance (loc1, loc2) result (dist)
    integer(kind = clk), intent(in) :: loc1, loc2
    real(kind = flk) :: dist

    integer(kind = cok) :: i1, j1
    integer(kind = cok) :: i2, j2
    integer :: di, dj

    i1 = i_coord (loc1)
    j1 = j_coord (loc1)
    i2 = i_coord (loc2)
    j2 = j_coord (loc2)
    di = i1 - i2
    dj = j1 - j2
    dist = sqrt (real ((di * di) + (dj * dj), kind = flk))
  end function distance

  function path_length (path) result (len)
    type(path_vector), intent(in) :: path
    real(kind = flk) :: len

    integer(kind = pik) :: i

    len = distance (path%elem(0_pik), path%elem(99_pik))
    do i = 0_pik, 98_pik
       len = len + distance (path%elem(i), path%elem(i + 1_pik))
    end do
  end function path_length

  subroutine find_neighbors (loc, neighbors, num_neighbors)
    integer(kind = clk), intent(in) :: loc
    integer(kind = clk), intent(out) :: neighbors(1:8)
    integer, intent(out) :: num_neighbors

    integer(kind = cok) :: i, j
    integer(kind = clk) :: c1, c2, c3, c4, c5, c6, c7, c8

    c1 = 0_clk
    c2 = 0_clk
    c3 = 0_clk
    c4 = 0_clk
    c5 = 0_clk
    c6 = 0_clk
    c7 = 0_clk
    c8 = 0_clk

    i = i_coord (loc)
    j = j_coord (loc)

    if (i < 9_cok) then
      c1 = location (i + 1_cok, j)
      if (j < 9_cok) then
        c2 = location (i + 1_cok, j + 1_cok)
      end if
      if (0_cok < j) then
        c3 = location (i + 1_cok, j - 1_cok)
      end if
    end if
    if (0_cok < i) then
      c4 = location (i - 1_cok, j)
      if (j < 9_cok) then
        c5 = location (i - 1_cok, j + 1_cok)
      end if
      if (0_cok < j) then
        c6 = location (i - 1_cok, j - 1_cok)
      end if
    end if
    if (j < 9_cok) then
      c7 = location (i, j + 1_cok)
    end if
    if (0_cok < j) then
      c8 = location (i, j - 1_cok)
    end if

    num_neighbors = 0
    call add_neighbor (c1)
    call add_neighbor (c2)
    call add_neighbor (c3)
    call add_neighbor (c4)
    call add_neighbor (c5)
    call add_neighbor (c6)
    call add_neighbor (c7)
    call add_neighbor (c8)

  contains

    subroutine add_neighbor (neighbor)
      integer(kind = clk), intent(in) :: neighbor

      if (neighbor /= 0_clk) then
         num_neighbors = num_neighbors + 1
         neighbors(num_neighbors) = neighbor
      end if
    end subroutine add_neighbor

  end subroutine find_neighbors

  function make_neighbor_path (path) result (neighbor_path)
    type(path_vector), intent(in) :: path
    type(path_vector) :: neighbor_path

    integer(kind = clk) :: u, v
    integer(kind = clk) :: neighbors(1:8)
    integer :: num_neighbors
    integer(kind = pik) :: j, iu, iv

    neighbor_path = path

    u = int (random_integer (1, 99), kind = clk)
    call find_neighbors (u, neighbors, num_neighbors)
    v = neighbors (random_integer (1, num_neighbors))

    j = 0_pik
    iu = 0_pik
    iv = 0_pik
    do while (iu == 0_pik .or. iv == 0_pik)
       if (neighbor_path%elem(j + 1) == u) then
          iu = j + 1
       else if (neighbor_path%elem(j + 1) == v) then
          iv = j + 1
       end if
       j = j + 1
    end do
    neighbor_path%elem(iu) = v
    neighbor_path%elem(iv) = u
  end function make_neighbor_path

  function temperature (kT, kmax, k) result (temp)
    real(kind = flk), intent(in) :: kT
    integer, intent(in) :: kmax, k
    real(kind = flk) :: temp

    real(kind = flk) :: kf, kmaxf

    kf = real (k, kind = flk)
    kmaxf = real (kmax, kind = flk)
    temp = kT * (1.0_flk - (kf / kmaxf))
  end function temperature

  function probability (delta_E, T) result (prob)
    real(kind = flk), intent(in) :: delta_E, T
    real(kind = flk) :: prob

    if (T == 0.0_flk) then
       prob = 0.0_flk
    else
       prob = exp (-(delta_E / T))
    end if
  end function probability

  subroutine show (k, T, E)
    integer, intent(in) :: k
    real(kind = flk), intent(in) :: T, E

    write (*, 10) k, T, E
10  format (1X, I7, 1X, F7.1, 1X, F10.2)
  end subroutine show

  subroutine display_path (path)
    type(path_vector), intent(in) :: path

    integer(kind = pik) :: i

999 format ()
100 format (' ->')
110 format (' ')
120 format (I2)

    do i = 0_pik, 99_pik
       write (*, 120, advance = 'no') path%elem(i)
       write (*, 100, advance = 'no')
       if (mod (i, 8_pik) == 7_pik) then
          write (*, 999, advance = 'yes')
       else
          write (*, 110, advance = 'no')
       end if
    end do
    write (*, 120, advance = 'no') path%elem(0_pik)
  end subroutine display_path

  subroutine simulate_annealing (kT, kmax, initial_path, final_path)
    real(kind = flk), intent(in) :: kT
    integer, intent(in) :: kmax
    type(path_vector), intent(in) :: initial_path
    type(path_vector), intent(inout) :: final_path

    integer :: kshow
    integer :: k
    real(kind = flk) :: E, E_trial, T
    type(path_vector) :: path, trial
    real(kind = flk) :: randnum

    kshow = kmax / 10

    path = initial_path
    E = path_length (path)
    do k = 0, kmax
       T = temperature (kT, kmax, k)
       if (mod (k, kshow) == 0) call show (k, T, E)
       trial = make_neighbor_path (path)
       E_trial = path_length (trial)
       if (E_trial <= E) then
          path = trial
          E = E_trial
       else
          call random_number (randnum)
          if (randnum <= probability (E_trial - E, T)) then
             path = trial
             E = E_trial
          end if
       end if
    end do
    final_path = path
  end subroutine simulate_annealing

end module simanneal_support

program simanneal

  use, non_intrinsic :: simanneal_support
  implicit none

  real(kind = flk), parameter :: kT = 1.0_flk
  integer, parameter :: kmax = 1000000

  type(path_vector) :: initial_path
  type(path_vector) :: final_path

  call random_seed

  call randomize_path_vector (initial_path)

10 format ()
20 format ('   kT: ', F0.2)
30 format ('   kmax: ', I0)
40 format ('       k       T       E(s)')
50 format (' --------------------------')
60 format ('Final E(s): ', F0.2)

  write (*, 10)
  write (*, 20) kT
  write (*, 30) kmax
  write (*, 10)
  write (*, 40)
  write (*, 50)
  call simulate_annealing (kT, kmax, initial_path, final_path)
  write (*, 10)
  call display_path (final_path)
  write (*, 10)
  write (*, 10)
  write (*, 60) path_length (final_path)
  write (*, 10)

end program simanneal
