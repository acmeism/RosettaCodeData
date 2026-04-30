program stable_marriage
  implicit none
  integer, parameter :: n = 10
  integer :: mens_pref(n, n), womens_pref(n, n)
  integer :: mens_rank(n, n), womens_rank(n, n)
  integer :: wife(n), husband(n), next_prop(n)
  logical :: free_men(n)
  character(len=4) :: men_names(n), women_names(n)
  integer :: m, w, p, h, i, curr_w, w1, w2
  logical :: is_stable

  ! Names
  men_names = ['abe ', 'bob ', 'col ', 'dan ', 'ed  ', 'fred', 'gav ', 'hal ', 'ian ', 'jon ']
  women_names = ['abi ', 'bea ', 'cath', 'dee ', 'eve ', 'fay ', 'gay ', 'hope', 'ivy ', 'jan ']

  ! Men's preferences
  mens_pref(1, :) = [1, 5, 3, 9, 10, 4, 6, 2, 8, 7]
  mens_pref(2, :) = [3, 8, 1, 4, 5, 6, 2, 10, 9, 7]
  mens_pref(3, :) = [8, 5, 1, 4, 2, 6, 9, 7, 3, 10]
  mens_pref(4, :) = [9, 6, 4, 7, 8, 5, 10, 2, 3, 1]
  mens_pref(5, :) = [10, 4, 2, 3, 6, 5, 1, 9, 8, 7]
  mens_pref(6, :) = [2, 1, 4, 7, 5, 9, 3, 10, 8, 6]
  mens_pref(7, :) = [7, 5, 9, 2, 3, 1, 4, 8, 10, 6]
  mens_pref(8, :) = [1, 5, 8, 6, 9, 3, 10, 2, 7, 4]
  mens_pref(9, :) = [8, 3, 4, 7, 2, 1, 6, 9, 10, 5]
  mens_pref(10, :) = [1, 6, 10, 7, 5, 2, 4, 3, 9, 8]

  ! Women's preferences
  womens_pref(1, :) = [2, 6, 10, 7, 9, 1, 4, 5, 3, 8]
  womens_pref(2, :) = [2, 1, 3, 6, 7, 4, 9, 5, 10, 8]
  womens_pref(3, :) = [6, 2, 5, 7, 8, 3, 9, 1, 4, 10]
  womens_pref(4, :) = [6, 10, 3, 1, 9, 8, 7, 4, 2, 5]
  womens_pref(5, :) = [10, 8, 6, 4, 1, 7, 3, 5, 9, 2]
  womens_pref(6, :) = [2, 1, 5, 9, 10, 4, 6, 7, 3, 8]
  womens_pref(7, :) = [10, 7, 8, 6, 2, 1, 3, 5, 4, 9]
  womens_pref(8, :) = [7, 10, 2, 1, 9, 4, 8, 5, 3, 6]
  womens_pref(9, :) = [9, 3, 8, 7, 6, 2, 1, 5, 10, 4]
  womens_pref(10, :) = [5, 8, 7, 1, 2, 10, 3, 9, 6, 4]

  ! Build rank matrices
  mens_rank = 0
  do m = 1, n
    do p = 1, n
      w = mens_pref(m, p)
      mens_rank(m, w) = p
    end do
  end do
  womens_rank = 0
  do w = 1, n
    do p = 1, n
      m = womens_pref(w, p)
      womens_rank(w, m) = p
    end do
  end do

  ! Gale-Shapley algorithm
  wife = 0
  husband = 0
  next_prop = 1
  free_men = .true.
  do while (any(free_men))
    do m = 1, n
      if (.not. free_men(m)) cycle
      if (next_prop(m) > n) cycle
      w = mens_pref(m, next_prop(m))
      next_prop(m) = next_prop(m) + 1
      if (husband(w) == 0) then
        husband(w) = m
        wife(m) = w
        free_men(m) = .false.
      else
        h = husband(w)
        if (womens_rank(w, m) < womens_rank(w, h)) then
          husband(w) = m
          wife(m) = w
          free_men(m) = .false.
          wife(h) = 0
          free_men(h) = .true.
        end if
      end if
    end do
  end do

  ! Print stable matching
  print *, 'Stable matching:'
  do m = 1, n
    print *, trim(men_names(m)), ' - ', trim(women_names(wife(m)))
  end do

  ! Check stability of stable matching
  is_stable = .true.
  do m = 1, n
    curr_w = wife(m)
    do i = 1, mens_rank(m, curr_w) - 1
      w = mens_pref(m, i)
      h = husband(w)
      if (womens_rank(w, m) < womens_rank(w, h)) then
        is_stable = .false.
      end if
    end do
  end do
  if (is_stable) then
    print *, 'The matching is stable.'
  else
    print *, 'The matching is not stable.'
  end if

  ! Perturb the matching (swap abe and bob's partners)
  w1 = wife(1)
  w2 = wife(2)
  wife(1) = w2
  wife(2) = w1
  husband(w1) = 2
  husband(w2) = 1

  ! Print perturbed matching
  print *, ''
  print *, 'Perturbed matching: (swap abe and bob''s partners)'
  do m = 1, n
    print *, trim(men_names(m)), ' - ', trim(women_names(wife(m)))
  end do

  ! Check stability of perturbed matching
  is_stable = .true.
  check_loop: do m = 1, n
    curr_w = wife(m)
    do i = 1, mens_rank(m, curr_w) - 1
      w = mens_pref(m, i)
      h = husband(w)
      if (womens_rank(w, m) < womens_rank(w, h)) then
        is_stable = .false.
        print *, 'Unstable because ', trim(men_names(m)), ' and ', trim(women_names(w)), &
          ' prefer each other while ', trim(men_names(h)), ' and ', trim(women_names(curr_w)), ' prefer each other'
        exit check_loop  ! Show one blocking pair
      end if
    end do
  end do check_loop
  if (is_stable) then
    print *, 'The perturbed matching is stable.'
  end if

end program stable_marriage
