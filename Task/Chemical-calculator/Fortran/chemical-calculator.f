program molar_mass_calc
  use iso_fortran_env, only: real64
  implicit none

  integer, parameter :: NELEM = 101
  character(len=3)    :: esym(NELEM)
  real(kind=real64)   :: emass(NELEM)
  character(len=256)  :: formula
  real(kind=real64)   :: mval
  integer             :: pos, ios

  data esym / &
    'H  ','He ','Li ','Be ','B  ','C  ','N  ','O  ','F  ','Ne ', &
    'Na ','Mg ','Al ','Si ','P  ','S  ','Cl ','K  ','Ar ','Ca ', &
    'Sc ','Ti ','V  ','Cr ','Mn ','Fe ','Ni ','Co ','Cu ','Zn ', &
    'Ga ','Ge ','As ','Se ','Br ','Kr ','Rb ','Sr ','Y  ','Zr ', &
    'Nb ','Mo ','Ru ','Rh ','Pd ','Ag ','Cd ','In ','Sn ','Sb ', &
    'I  ','Te ','Xe ','Cs ','Ba ','La ','Ce ','Pr ','Nd ','Pm ', &
    'Sm ','Eu ','Gd ','Tb ','Dy ','Ho ','Er ','Tm ','Yb ','Lu ', &
    'Hf ','Ta ','W  ','Re ','Os ','Ir ','Pt ','Au ','Hg ','Tl ', &
    'Pb ','Bi ','Po ','At ','Rn ','Fr ','Ra ','Ac ','Pa ','Th ', &
    'Np ','U  ','Am ','Pu ','Cm ','Bk ','Cf ','Es ','Fm ',       &
    'Ubn','Uue' /

  data emass / &
      1.008D0,      4.002602D0,    6.94D0,      9.0121831D0, &
     10.81D0,      12.011D0,       14.007D0,    15.999D0,    &
     18.998403163D0, 20.1797D0,    22.98976928D0, 24.305D0,  &
     26.9815385D0, 28.085D0,       30.973761998D0, 32.06D0,  &
     35.45D0,      39.0983D0,      39.948D0,    40.078D0,    &
     44.955908D0,  47.867D0,       50.9415D0,   51.9961D0,   &
     54.938044D0,  55.845D0,       58.6934D0,   58.933194D0, &
     63.546D0,     65.38D0,        69.723D0,    72.63D0,     &
     74.921595D0,  78.971D0,       79.904D0,    83.798D0,    &
     85.4678D0,    87.62D0,        88.90584D0,  91.224D0,    &
     92.90637D0,   95.95D0,       101.07D0,    102.9055D0,   &
    106.42D0,     107.8682D0,     112.414D0,   114.818D0,    &
    118.71D0,     121.76D0,       126.90447D0, 127.6D0,      &
    131.293D0,    132.90545196D0, 137.327D0,   138.90547D0,  &
    140.116D0,    140.90766D0,    144.242D0,   145.0D0,      &
    150.36D0,     151.964D0,      157.25D0,    158.92535D0,  &
    162.5D0,      164.93033D0,    167.259D0,   168.93422D0,  &
    173.054D0,    174.9668D0,     178.49D0,    180.94788D0,  &
    183.84D0,     186.207D0,      190.23D0,    192.217D0,    &
    195.084D0,    196.966569D0,   200.592D0,   204.38D0,     &
    207.2D0,      208.9804D0,     209.0D0,     210.0D0,      &
    222.0D0,      223.0D0,        226.0D0,     227.0D0,      &
    231.03588D0,  232.0377D0,     237.0D0,     238.02891D0,  &
    243.0D0,      244.0D0,        247.0D0,     247.0D0,      &
    251.0D0,      252.0D0,        257.0D0,                   &
    299.0D0,      315.0D0 /

  ! Built-in test compounds (longest formula is 18 chars)
  integer, parameter :: NTEST = 11
  character(len=18), parameter :: test_formula(NTEST) = [ &
    'H                 ', &
    'H2                ', &
    'H2O               ', &
    'H2O2              ', &
    '(HO)2             ', &
    'Na2SO4            ', &
    'C6H12             ', &
    'COOH(C(CH3)2)3CH3 ', &
    'C6H4O2(OH)4       ', &
    'C27H46O           ', &
    'Uue               '  ]
  integer            :: k
  character(len=18)  :: tf

  write(*,'(A)') 'Molar Mass Calculator'
  write(*,'(A)') '----------------------------------'
  do k = 1, NTEST
    tf  = adjustr(test_formula(k))   ! right-justify in 18-char field
    pos = 1
    mval = calc_mass(trim(adjustl(tf)), pos)
    write(*,'(A18,A,F8.3)') tf, ' -> ', mval
  end do
  write(*,'(A)') '----------------------------------'
  write(*,*)
  write(*,'(A)') 'Enter chemical formula (blank line to quit):'

  do
    write(*,'(A)', advance='no') '> '
    read(*,'(A)', iostat=ios) formula
    if (ios /= 0) exit
    formula = trim(adjustl(formula))
    if (len_trim(formula) == 0) exit
    pos  = 1
    mval = calc_mass(trim(formula), pos)
    write(*,'(4A,F12.6,A)') 'Molar mass of ', trim(formula), &
                              ' = ', '', mval, ' g/mol'
  end do

contains

  ! ----------------------------------------------------------------
  ! Recursive descent parser.
  ! Advances pos through f, stopping at ')' or end of string.
  ! The caller is responsible for consuming the closing ')'.
  ! ----------------------------------------------------------------
  recursive function calc_mass(f, pos) result(total)
    character(len=*), intent(in)    :: f
    integer,          intent(inout) :: pos
    real(kind=real64)               :: total
    real(kind=real64)               :: sub, am
    character(len=3)                :: sym
    integer                         :: slen, cnt, flen

    total = 0.0_real64
    flen  = len(f)

    do while (pos <= flen)

      if (f(pos:pos) == ')') exit    ! return to parent group

      if (f(pos:pos) == '(') then
        ! --- parenthesised group ---
        pos = pos + 1                ! skip '('
        sub = calc_mass(f, pos)      ! recurse; pos ends on ')'
        if (pos <= flen .and. f(pos:pos) == ')') pos = pos + 1
        cnt   = read_int(f, pos)
        total = total + sub * real(cnt, real64)

      else if ((f(pos:pos) >= 'A' .and. f(pos:pos) <= 'Z') .or. &
               (f(pos:pos) >= 'a' .and. f(pos:pos) <= 'z')) then
        ! --- greedy element match: try 3 chars, then 2, then 1 ---
        ! Collect up to 3 consecutive letters; canonicalise as Xxx.
        slen = 0
        sym  = '   '
        do while (pos + slen <= flen .and. slen < 3)
          if ((f(pos+slen:pos+slen) >= 'A' .and. f(pos+slen:pos+slen) <= 'Z') .or. &
              (f(pos+slen:pos+slen) >= 'a' .and. f(pos+slen:pos+slen) <= 'z')) then
            slen = slen + 1
            if (slen == 1) then
              ! first letter: uppercase
              if (f(pos:pos) >= 'a' .and. f(pos:pos) <= 'z') then
                sym(1:1) = char(ichar(f(pos:pos)) - 32)
              else
                sym(1:1) = f(pos:pos)
              end if
            else
              ! continuation: lowercase
              if (f(pos+slen-1:pos+slen-1) >= 'A' .and. &
                  f(pos+slen-1:pos+slen-1) <= 'Z') then
                sym(slen:slen) = char(ichar(f(pos+slen-1:pos+slen-1)) + 32)
              else
                sym(slen:slen) = f(pos+slen-1:pos+slen-1)
              end if
            end if
          else
            exit
          end if
        end do
        ! Try longest match first, fall back to shorter
        am = -1.0_real64
        do while (slen >= 1)
          am = lookup_mass(sym(1:slen))
          if (am >= 0.0_real64) exit
          slen = slen - 1
        end do
        if (slen == 0) then
          write(*,'(3A)') 'Warning: unknown element "', trim(sym), '"'
          pos = pos + 1   ! skip the unrecognised letter
          cycle
        end if
        pos   = pos + slen
        cnt   = read_int(f, pos)
        total = total + am * real(cnt, real64)

      else
        pos = pos + 1                ! skip unrecognised character
      end if

    end do

  end function calc_mass

  ! ----------------------------------------------------------------
  ! Read an optional integer at position pos; default 1 if absent.
  ! ----------------------------------------------------------------
  function read_int(f, pos) result(val)
    character(len=*), intent(in)    :: f
    integer,          intent(inout) :: pos
    integer                         :: val
    integer                         :: flen

    flen = len(f)
    val  = 0
    do while (pos <= flen .and. f(pos:pos) >= '0' .and. f(pos:pos) <= '9')
      val = val * 10 + ichar(f(pos:pos)) - ichar('0')
      pos = pos + 1
    end do
    if (val == 0) val = 1
  end function read_int

  ! ----------------------------------------------------------------
  ! Linear search through the element table.
  ! ----------------------------------------------------------------
  function lookup_mass(sym) result(mass)
    character(len=*), intent(in) :: sym
    real(kind=real64)            :: mass
    integer                      :: i

    do i = 1, NELEM
      if (trim(esym(i)) == trim(sym)) then
        mass = emass(i)
        return
      end if
    end do
    mass = -1.0_real64   ! signals no match to the greedy caller
  end function lookup_mass

end program molar_mass_calc

