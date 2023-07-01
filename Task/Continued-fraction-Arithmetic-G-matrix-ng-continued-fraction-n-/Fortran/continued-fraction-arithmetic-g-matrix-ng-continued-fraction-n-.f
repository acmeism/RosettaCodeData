!---------------------------------------------------------------------

module continued_fractions
  !
  ! Continued fractions with memoization.
  !

  implicit none
  private

  public :: cf_generator_proc_t
  public :: cf_generator_t
  public :: cf_t

  public :: cf_generator_make
  public :: cf_make
  public :: cf_generator_make_from_cf

  public :: cf_get_at

  public :: cf2string_max_terms
  public :: cf2string_default_max_terms
  public :: cf2string
  public :: default_max_terms

  integer :: default_max_terms = 20

  interface
     subroutine cf_generator_proc_t (env, term_exists, term)
       class(*), intent(inout) :: env
       logical, intent(out) :: term_exists
       integer, intent(out) :: term
     end subroutine cf_generator_proc_t
  end interface

  type :: cf_generator_t
     procedure(cf_generator_proc_t), pointer, nopass :: proc
     class(*), pointer :: env
     integer :: refcount = 0
   contains
     final :: cf_generator_t_finalize
     procedure :: cf_generator_t_refcount_incr
     procedure :: cf_generator_t_refcount_decr
  end type cf_generator_t

  type :: cf_memo_t
     integer, pointer :: storage(:)
     integer :: refcount = 0
   contains
     final :: cf_memo_t_finalize
     procedure :: cf_memo_t_refcount_incr
     procedure :: cf_memo_t_refcount_decr
  end type cf_memo_t

  type :: cf_t
     logical :: terminated
     integer :: m
     integer :: n
     class(cf_memo_t), pointer :: memo
     class(cf_generator_t), pointer :: gen
   contains
     final :: cf_t_finalize
  end type cf_t

  interface cf2string
     !
     ! Overload the name "cf2string".
     !
     module procedure cf2string_max_terms
     module procedure cf2string_default_max_terms
  end interface

  type :: cf_generator_from_cf_env_t
     class(cf_t), pointer :: cf
     integer :: i
  end type cf_generator_from_cf_env_t

contains

  recursive subroutine cf_generator_make (gen, proc, env)
    type(cf_generator_t), intent(out), pointer :: gen
    interface
       subroutine proc (env, term_exists, term)
         class(*), intent(inout) :: env
         logical, intent(out) :: term_exists
         integer, intent(out) :: term
       end subroutine proc
    end interface
    class(*), pointer, intent(inout) :: env

    allocate (gen)
    gen%proc => proc
    gen%env => env
  end subroutine cf_generator_make

  subroutine cf_generator_t_refcount_incr (gen)
    class(cf_generator_t), intent(inout) :: gen
    gen%refcount = gen%refcount + 1
  end subroutine cf_generator_t_refcount_incr

  subroutine cf_generator_t_refcount_decr (gen)
    class(cf_generator_t), intent(inout) :: gen
    gen%refcount = gen%refcount - 1
  end subroutine cf_generator_t_refcount_decr

  recursive subroutine cf_generator_t_finalize (gen)
    type(cf_generator_t), intent(inout) :: gen
    deallocate (gen%env)
  end subroutine cf_generator_t_finalize

  subroutine cf_memo_t_refcount_incr (memo)
    class(cf_memo_t), intent(inout) :: memo
    memo%refcount = memo%refcount + 1
  end subroutine cf_memo_t_refcount_incr

  subroutine cf_memo_t_refcount_decr (memo)
    class(cf_memo_t), intent(inout) :: memo
    memo%refcount = memo%refcount - 1
  end subroutine cf_memo_t_refcount_decr

  recursive subroutine cf_memo_t_finalize (memo)
    type(cf_memo_t), intent(inout) :: memo
    deallocate (memo%storage)
  end subroutine cf_memo_t_finalize

  recursive subroutine cf_make (cf, gen)
    type(cf_t), pointer, intent(out) :: cf
    type(cf_generator_t), pointer, intent(inout) :: gen

    integer, parameter :: start_size = 8

    allocate (cf)
    allocate (cf%memo)
    allocate (cf%memo%storage(0 : start_size - 1))
    cf%terminated = .false.
    cf%m = 0
    cf%n = start_size
    cf%gen => gen

    call cf%memo%cf_memo_t_refcount_incr
    call cf%gen%cf_generator_t_refcount_incr
  end subroutine cf_make

  recursive subroutine cf_t_finalize (cf)
    type(cf_t), intent(inout) :: cf

    call cf%memo%cf_memo_t_refcount_decr
    if (cf%memo%refcount == 0) deallocate (cf%memo)

    call cf%gen%cf_generator_t_refcount_decr
    if (cf%gen%refcount == 0) deallocate (cf%gen)
  end subroutine cf_t_finalize

  recursive subroutine cf_generator_make_from_cf (gen, cf)
    !
    ! TAKE NOTE: deallocating gen DOES NOT deallocate cf. (Most likely
    ! you would not want it to do so.)
    !
    type(cf_generator_t), intent(out), pointer :: gen
    type(cf_t), pointer, intent(inout) :: cf

    type(cf_generator_from_cf_env_t), pointer :: env
    class(*), pointer :: p

    allocate (env)
    env%cf => cf
    env%i = 0

    p => env
    call cf_generator_make (gen, cf_generator_from_cf_proc, p)
  end subroutine cf_generator_make_from_cf

  recursive subroutine cf_generator_from_cf_proc (env, term_exists, term)
    class(*), intent(inout) :: env
    logical, intent(out) :: term_exists
    integer, intent(out) :: term

    select type (env)
    class is (cf_generator_from_cf_env_t)
       call cf_get_at (env%cf, env%i, term_exists, term)
       env%i = env%i + 1
    end select
  end subroutine cf_generator_from_cf_proc

  recursive subroutine cf_get_more_terms (cf, needed)
    class(cf_t), intent(inout) :: cf
    integer, intent(in) :: needed

    integer :: term_count
    logical :: done

    logical :: term_exists
    integer :: term

    term_count = cf%m
    done = .false.
    do while (.not. done)
       if (term_count == needed) then
          cf%m = needed
          done = .true.
       else
          call cf%gen%proc (cf%gen%env, term_exists, term)
          if (term_exists) then
             cf%memo%storage(term_count) = term
             term_count = term_count + 1
          else
             cf%terminated = .true.
             cf%m = term_count
             done = .true.
          end if
       end if
    end do
  end subroutine cf_get_more_terms

  recursive subroutine cf_update (cf, needed)
    class(cf_t), intent(inout) :: cf
    integer, intent(in) :: needed

    integer, pointer :: storage1(:)

    if (cf%terminated .or. needed <= cf%m) then
       continue
    else if (needed <= cf%n) then
       call cf_get_more_terms (cf, needed)
    else
       ! Provide twice the needed storage.
       cf%n = 2 * needed
       allocate (storage1(0:cf%n - 1))
       storage1(0:cf%m - 1) = cf%memo%storage(0:cf%m - 1)
       deallocate (cf%memo%storage)
       cf%memo%storage => storage1
       call cf_get_more_terms (cf, needed)
    end if
  end subroutine cf_update

  recursive subroutine cf_get_at (cf, i, term_exists, term)
    class(cf_t), intent(inout) :: cf
    integer, intent(in) :: i
    logical, intent(out) :: term_exists
    integer, intent(out) :: term

    call cf_update (cf, i + 1)
    term_exists = (i < cf%m)
    if (term_exists) term = cf%memo%storage(i)
  end subroutine cf_get_at

  recursive function cf2string_max_terms (cf, max_terms) result (s)
    class(cf_t), intent(inout) :: cf
    integer, intent(in) :: max_terms
    character(len = :), allocatable :: s

    integer :: sep
    integer :: i, j
    logical :: done

    logical :: term_exists
    integer :: term

    character(len = 100) :: buf

    s = "["
    sep = 0
    i = 0
    done = .false.
    do while (.not. done)
       if (i == max_terms) then
          s = s // ",...]"
          done = .true.
       else
          call cf_get_at (cf, i, term_exists, term)
          if (term_exists) then
             select case (sep)
             case(0)
                sep = 1
             case(1)
                s = s // ";"
                sep = 2
             case(2)
                s = s // ","
             end select

             write (buf, '(I100)') term
             j = 1
             do while (buf(j:j) == ' ')
                j = j + 1
             end do
             s = s // buf(j:100)

             i = i + 1
          else
             s = s // "]"
             done = .true.
          end if
       end if
    end do
  end function cf2string_max_terms

  recursive function cf2string_default_max_terms (cf) result (s)
    class(cf_t), intent(inout) :: cf
    character(len = :), allocatable :: s
    s = cf2string_max_terms (cf, default_max_terms)
  end function cf2string_default_max_terms

end module continued_fractions

!---------------------------------------------------------------------

module continued_fractions_r2cf
  !
  ! Rational numbers.
  !

  use, non_intrinsic :: continued_fractions

  implicit none

  public :: r2cf_generator_make
  public :: r2cf_make

  type :: r2cf_generator_env_t
     integer :: n, d
  end type r2cf_generator_env_t

contains

  recursive subroutine r2cf_generator_make (gen, n, d)
    type(cf_generator_t), pointer, intent(out) :: gen
    integer, intent(in) :: n, d

    type(r2cf_generator_env_t), pointer :: env
    class(*), pointer :: p

    allocate (env)
    env%n = n
    env%d = d

    p => env
    call cf_generator_make (gen, r2cf_generator_proc, p)
  end subroutine r2cf_generator_make

  recursive subroutine r2cf_generator_proc (env, term_exists, term)
    class(*), intent(inout) :: env
    logical, intent(out) :: term_exists
    integer, intent(out) :: term

    integer :: q, r

    select type (env)
    class is (r2cf_generator_env_t)
       term_exists = (env%d /= 0)
       if (term_exists) then

          ! The direction in which to round the quotient is
          ! arbitrary. We will round it towards negative infinity.
          r = modulo (env%n, env%d)
          q = (env%n - r) / env%d

          env%n = env%d
          env%d = r

          term = q
       end if
    end select
  end subroutine r2cf_generator_proc

  recursive subroutine r2cf_make (cf, n, d)
    type(cf_t), pointer, intent(out) :: cf
    integer, intent(in) :: n, d

    type(cf_generator_t), pointer :: gen

    allocate (gen)
    call r2cf_generator_make (gen, n, d)
    call cf_make (cf, gen)
  end subroutine r2cf_make

end module continued_fractions_r2cf

!---------------------------------------------------------------------

module continued_fractions_sqrt2
  !
  ! The square root of two.
  !

  use, non_intrinsic :: continued_fractions

  implicit none

  public :: sqrt2_generator_make
  public :: sqrt2_make

  type :: sqrt2_generator_env_t
     integer :: term
  end type sqrt2_generator_env_t

contains

  recursive subroutine sqrt2_generator_make (gen)
    type(cf_generator_t), pointer, intent(out) :: gen

    type(sqrt2_generator_env_t), pointer :: env
    class(*), pointer :: p

    allocate (env)
    env%term = 1

    p => env
    call cf_generator_make (gen, sqrt2_generator_proc, p)
  end subroutine sqrt2_generator_make

  recursive subroutine sqrt2_generator_proc (env, term_exists, term)
    class(*), intent(inout) :: env
    logical, intent(out) :: term_exists
    integer, intent(out) :: term

    select type (env)
    class is (sqrt2_generator_env_t)
       term_exists = .true.
       term = env%term
       env%term = 2
    end select
  end subroutine sqrt2_generator_proc

  recursive subroutine sqrt2_make (cf)
    type(cf_t), pointer, intent(out) :: cf

    type(cf_generator_t), pointer :: gen

    allocate (gen)
    call sqrt2_generator_make (gen)
    call cf_make (cf, gen)
  end subroutine sqrt2_make

end module continued_fractions_sqrt2

!---------------------------------------------------------------------

module continued_fractions_hfunc
  !
  ! Homographic functions of cf_t objects.
  !

  use, non_intrinsic :: continued_fractions

  implicit none

  public :: hfunc_make

  type :: hfunc_generator_env_t
     integer :: a1, a, b1, b
     class(cf_generator_t), allocatable :: source_gen
  end type hfunc_generator_env_t

contains

  recursive subroutine hfunc_generator_make (gen, a1, a, b1, b, source_gen)
    type(cf_generator_t), pointer, intent(out) :: gen
    integer, intent(in) :: a1, a, b1, b
    type(cf_generator_t), pointer, intent(inout) :: source_gen

    type(hfunc_generator_env_t), pointer :: env
    class(*), pointer :: p

    allocate (env)
    env%a1 = a1
    env%a = a
    env%b1 = b1
    env%b = b
    env%source_gen = source_gen

    p => env
    call cf_generator_make (gen, hfunc_generator_proc, p)
  end subroutine hfunc_generator_make

  recursive subroutine hfunc_generator_proc (env, term_exists, term)
    class(*), intent(inout) :: env
    logical, intent(out) :: term_exists
    integer, intent(out) :: term

    integer :: q1, q
    logical :: done

    select type (env)
    class is (hfunc_generator_env_t)
       done = .false.
       do while (.not. done)
          if (env%b1 == 0 .and. env%b == 0) then
             term_exists = .false.
             done = .true.
          else if (env%b1 /= 0 .and. env%b /= 0) then

             ! Because I feel like it, let us round quotients
             ! towards negative infinity.
             q1 = (env%a1 - modulo (env%a1, env%b1)) / env%b1
             q = (env%a - modulo (env%a, env%b)) / env%b

             if (q1 == q) then
                block
                  integer :: a1, a, b1, b
                  a1 = env%a1
                  a = env%a
                  b1 = env%b1
                  b = env%b
                  env%a1 = b1
                  env%a = b
                  env%b1 = a1 - (b1 * q)
                  env%b = a - (b * q)
                  term_exists = .true.
                  term = q
                  done = .true.
                end block
             end if
          end if

          if (.not. done) then
             call env%source_gen%proc (env%source_gen%env, term_exists, term)
             if (term_exists) then
                block
                  integer :: a1, a, b1, b
                  a1 = env%a1
                  a = env%a
                  b1 = env%b1
                  b = env%b
                  env%a1 = a + (a1 * term)
                  env%a = a1
                  env%b1 = b + (b1 * term)
                  env%b = b1
                end block
             else
                env%a = env%a1
                env%b = env%b1
             end if
          end if
       end do

    end select

  end subroutine hfunc_generator_proc

  recursive subroutine hfunc_make (cf, a1, a, b1, b, source_cf)
    type(cf_t), pointer, intent(out) :: cf
    integer, intent(in) :: a1, a, b1, b
    type(cf_t), pointer, intent(inout) :: source_cf

    type(cf_generator_t), pointer :: gen
    class(cf_generator_t), pointer :: source_gen

    call cf_generator_make_from_cf (source_gen, source_cf)
    call hfunc_generator_make (gen, a1, a, b1, b, source_gen)
    call cf_make (cf, gen)
  end subroutine hfunc_make

end module continued_fractions_hfunc

!---------------------------------------------------------------------

program univariate_continued_fraction_task

  use, non_intrinsic :: continued_fractions
  use, non_intrinsic :: continued_fractions_r2cf
  use, non_intrinsic :: continued_fractions_sqrt2
  use, non_intrinsic :: continued_fractions_hfunc

  implicit none

  type(cf_t), pointer :: cf_13_11
  type(cf_t), pointer :: cf_22_7
  type(cf_t), pointer :: cf_sqrt2

  type(cf_t), pointer :: cf_13_11_add_1_2
  type(cf_t), pointer :: cf_22_7_add_1_2
  type(cf_t), pointer :: cf_22_7_div_4
  type(cf_t), pointer :: cf_sqrt2_div_2
  type(cf_t), pointer :: cf_1_div_sqrt2
  type(cf_t), pointer :: cf_one_way
  type(cf_t), pointer :: cf_another_way

  type(cf_t), pointer :: cf_half_of_1_div_sqrt2
  type(cf_t), pointer :: cf_a_third_way

  call r2cf_make (cf_13_11, 13, 11)
  call r2cf_make (cf_22_7, 22, 7)
  call sqrt2_make (cf_sqrt2)

  call hfunc_make (cf_13_11_add_1_2, 2, 1, 0, 2, cf_13_11)
  call hfunc_make (cf_22_7_add_1_2, 2, 1, 0, 2, cf_22_7)
  call hfunc_make (cf_22_7_div_4, 1, 0, 0, 4, cf_22_7)
  call hfunc_make (cf_sqrt2_div_2, 1, 0, 0, 2, cf_sqrt2)
  call hfunc_make (cf_1_div_sqrt2, 0, 1, 1, 0, cf_sqrt2)
  call hfunc_make (cf_one_way, 1, 2, 0, 4, cf_sqrt2)
  call hfunc_make (cf_another_way, 1, 1, 0, 2, cf_1_div_sqrt2)

  call hfunc_make (cf_half_of_1_div_sqrt2, 1, 0, 0, 2, cf_1_div_sqrt2)
  call hfunc_make (cf_a_third_way, 2, 1, 0, 2, cf_half_of_1_div_sqrt2)

  write (*, '("13/11 => ", A)') cf2string (cf_13_11)
  write (*, '("22/7 => ", A)') cf2string (cf_22_7)
  write (*, '("sqrt(2) => ", A)') cf2string (cf_sqrt2)

  write (*, '("13/11 + 1/2 => ", A)') cf2string (cf_13_11_add_1_2)
  write (*, '("22/7 + 1/2 => ", A)') cf2string (cf_22_7_add_1_2)
  write (*, '("(22/7)/4 => ", A)') cf2string (cf_22_7_div_4)
  write (*, '("sqrt(2)/2 => ", A)') cf2string (cf_sqrt2_div_2)
  write (*, '("1/sqrt(2) => ", A)') cf2string (cf_1_div_sqrt2)
  write (*, '("(2 + sqrt(2))/4 => ", A)') cf2string (cf_one_way)
  write (*, '("(1 + 1/sqrt(2))/2 => ", A)') cf2string (cf_another_way)
  write (*, '("(1/sqrt(2))/2 + 1/2 => ", A)') cf2string (cf_a_third_way)

  deallocate (cf_13_11)
  deallocate (cf_22_7)
  deallocate (cf_sqrt2)
  deallocate (cf_13_11_add_1_2)
  deallocate (cf_22_7_add_1_2)
  deallocate (cf_22_7_div_4)
  deallocate (cf_sqrt2_div_2)
  deallocate (cf_1_div_sqrt2)
  deallocate (cf_one_way)
  deallocate (cf_another_way)
  deallocate (cf_half_of_1_div_sqrt2)
  deallocate (cf_a_third_way)

end program univariate_continued_fraction_task

!---------------------------------------------------------------------
