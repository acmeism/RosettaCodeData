!! =============================================================================
! air_mass.f90  --  Astronomical Air Mass Calculation
! =============================================================================
!
! Air mass is a measure of the thickness of atmosphere a ray of light must
! traverse when arriving at an observer from a celestial object.  At the
! zenith (z = 0) the air mass is 1.0 by definition.  As the zenith angle
! increases the ray travels through progressively more atmosphere.
!
! MODEL
! -----
! We treat the atmosphere as a spherically-symmetric shell around a spherical
! Earth.  The density at height h (metres above sea level) follows an
! exponential law:
!
!   rho(h)  =  rho_0 * exp(-h / H)
!
! where H = 8 500 m is the pressure scale height and rho_0 is the sea-level
! density (it cancels out of the ratio).
!
! The line of sight from an observer at altitude a, looking at zenith angle z,
! is parameterised by the path length x measured along the ray from the
! observer.  The height h at path length x is given by the law of cosines
! applied to the triangle (centre of Earth, observer, point on ray):
!
!   r0  = R_EARTH + a                       (observer geocentric radius)
!   r(x) = sqrt( r0^2 + x^2 + 2*r0*x*cos(z) )
!
!   Note: cos(z) is positive for z < 90 (ray pointing upward),
!         zero for z = 90 (horizontal), and negative beyond.
!
!   h(x) = r(x) - R_EARTH                  (height above sea level)
!
! AIR MASS INTEGRAL
! -----------------
! The raw column density integral is:
!
!   I(a, z) = integral_0^{X_MAX} exp(-h(x) / H)  dx
!
! We normalise by the vertical (zenith) integral evaluated analytically:
!
!   I_zenith(a) = H * exp(-a / H)
!
! so that air_mass(a, 0) = 1.0 exactly and the result is dimensionless.
!
! NUMERICAL INTEGRATION
! ---------------------
! Composite Simpson's rule with N_STEPS (even) sub-intervals is used.
! X_MAX = 2 000 000 m (2 000 km) is far enough that exp(-h/H) is
! negligibly small beyond the upper boundary.
!
! FLAT-EARTH (PLANE-PARALLEL) APPROXIMATION
! ------------------------------------------
! The classic first-order approximation ignores Earth curvature:
!
!   air_mass_flat = 1 / cos(z)
!
! This is accurate for small z but diverges as z -> 90 degrees.
!
! OUTPUT
! ------
! Two tables are printed:
!   1. Sea-level observer  (a = 0 m)
!   2. NASA SOFIA aircraft (a = 13 700 m)
!
! Each row shows z, spherical air mass, and the flat-Earth value.
! =============================================================================
program air_mass_program
  use iso_fortran_env, only: real64
  implicit none

  ! --------------------------------------------------------------------------
  ! Physical constants and integration parameters
  ! --------------------------------------------------------------------------
  real(kind=real64), parameter :: R_EARTH  = 6371000.0_real64  ! Earth radius (m)
  real(kind=real64), parameter :: H_SCALE  = 8500.0_real64     ! pressure scale height (m)
  real(kind=real64), parameter :: X_MAX    = 2000000.0_real64  ! path length limit (m)
  integer,           parameter :: N_STEPS  = 2**17             ! Simpson sub-intervals (131072, must be even)

  ! Conversion factor
  real(kind=real64), parameter :: DEG2RAD  = acos(-1.0_real64) / 180.0_real64

  ! Observer altitudes (m)
  real(kind=real64), parameter :: ALT_SEA   =     0.0_real64   ! sea level
  real(kind=real64), parameter :: ALT_SOFIA = 13700.0_real64   ! SOFIA cruising altitude

  ! --------------------------------------------------------------------------
  ! Local variables
  ! --------------------------------------------------------------------------
  integer           :: iz
  real(kind=real64) :: z_deg, z_rad
  real(kind=real64) :: am_sea, am_sofia, am_flat

  ! --------------------------------------------------------------------------
  ! Table: sea-level observer
  ! --------------------------------------------------------------------------
  write(*, '(a)') '============================================================='
  write(*, '(a)') ' Air Mass Table -- Sea-level observer  (a = 0 m)'
  write(*, '(a)') '============================================================='
  write(*, '(a)') '  z (deg)   Spherical    Flat (1/cos z)'
  write(*, '(a)') ' --------  ----------   ---------------'

  do iz = 0, 18
    z_deg = real(iz * 5, real64)
    z_rad = z_deg * DEG2RAD

    am_sea  = air_mass(ALT_SEA, z_rad)

    if (iz < 18) then
      am_flat = 1.0_real64 / cos(z_rad)
      write(*, '(f9.1, f13.5, f16.5)') z_deg, am_sea, am_flat
    else
      ! z = 90 deg: flat-Earth value is infinite
      write(*, '(f9.1, f13.5, a)') z_deg, am_sea, '          Inf'
    end if
  end do

  write(*, *)

  ! --------------------------------------------------------------------------
  ! Table: SOFIA observer
  ! --------------------------------------------------------------------------
  write(*, '(a)') '============================================================='
  write(*, '(a)') ' Air Mass Table -- NASA SOFIA  (a = 13 700 m)'
  write(*, '(a)') '============================================================='
  write(*, '(a)') '  z (deg)   Spherical    Flat (1/cos z)'
  write(*, '(a)') ' --------  ----------   ---------------'

  do iz = 0, 18
    z_deg = real(iz * 5, real64)
    z_rad = z_deg * DEG2RAD

    am_sofia = air_mass(ALT_SOFIA, z_rad)

    if (iz < 18) then
      am_flat = 1.0_real64 / cos(z_rad)
      write(*, '(f9.1, f13.5, f16.5)') z_deg, am_sofia, am_flat
    else
      write(*, '(f9.1, f13.5, a)') z_deg, am_sofia, '          Inf'
    end if
  end do

  write(*, *)

  ! --------------------------------------------------------------------------
  ! Side-by-side comparison at selected angles
  ! --------------------------------------------------------------------------
  write(*, '(a)') '============================================================='
  write(*, '(a)') ' Comparison: Sea level vs SOFIA vs Flat-Earth'
  write(*, '(a)') '============================================================='
  write(*, '(a)') '  z (deg)   Sea level    SOFIA      Flat (1/cos z)'
  write(*, '(a)') ' --------  ----------  ----------  ---------------'

  do iz = 0, 18
    z_deg = real(iz * 5, real64)
    z_rad = z_deg * DEG2RAD

    am_sea  = air_mass(ALT_SEA,   z_rad)
    am_sofia = air_mass(ALT_SOFIA, z_rad)

    if (iz < 18) then
      am_flat = 1.0_real64 / cos(z_rad)
      write(*, '(f9.1, f12.5, f12.5, f16.5)') z_deg, am_sea, am_sofia, am_flat
    else
      write(*, '(f9.1, f12.5, f12.5, a)') z_deg, am_sea, am_sofia, '          Inf'
    end if
  end do

  write(*, *)
  write(*, '(a)') 'Notes:'
  write(*, '(a)') '  Spherical model: composite Simpsons rule, N = 131 072 intervals'
  write(*, '(a)') '  Scale height H = 8 500 m,  R_Earth = 6 371 000 m'
  write(*, '(a)') '  SOFIA cruising altitude = 13 700 m  (~45 000 ft)'
  write(*, '(a)') '  Air mass is normalised so that the zenith value = 1.0'

contains

  ! ==========================================================================
  ! air_mass(a, z)  --  compute air mass for observer at altitude a (m)
  !                     looking at zenith angle z (radians).
  !
  ! Uses composite Simpson's rule to evaluate:
  !
  !   I(a,z) = integral_0^{X_MAX} exp(-h(x)/H_SCALE) dx
  !
  ! then returns  I(a,z) / (H_SCALE * exp(-a/H_SCALE))
  !
  ! so that the zenith air mass is 1.0 by definition.
  ! ==========================================================================
  function air_mass(a, z) result(am)
    real(kind=real64), intent(in) :: a   ! observer altitude above sea level (m)
    real(kind=real64), intent(in) :: z   ! zenith angle (radians)
    real(kind=real64) :: am

    real(kind=real64) :: r0       ! geocentric radius of observer (m)
    real(kind=real64) :: dx       ! step size along ray (m)
    real(kind=real64) :: cz       ! cos(z), precomputed for efficiency
    real(kind=real64) :: integral ! accumulated Simpson sum
    real(kind=real64) :: x        ! current path length (m)
    real(kind=real64) :: h        ! height above sea level at x (m)
    real(kind=real64) :: w        ! Simpson weight (1, 4, or 2)
    real(kind=real64) :: zenith_I ! analytic zenith column: H * exp(-a/H)
    integer :: i

    r0 = R_EARTH + a
    dx = X_MAX / real(N_STEPS, real64)
    cz = cos(z)

    ! Simpson's rule: sum weights 1, 4, 2, 4, 2, ..., 4, 1
    integral = 0.0_real64
    do i = 0, N_STEPS
      x = real(i, real64) * dx

      ! Height at this point via law of cosines
      h = sqrt(r0*r0 + x*x + 2.0_real64*r0*x*cz) - R_EARTH

      ! Clamp h to zero to avoid negative heights at extreme angles
      if (h < 0.0_real64) h = 0.0_real64

      ! Simpson weights
      if (i == 0 .or. i == N_STEPS) then
        w = 1.0_real64
      else if (mod(i, 2) == 1) then
        w = 4.0_real64
      else
        w = 2.0_real64
      end if

      integral = integral + w * exp(-h / H_SCALE)
    end do
    integral = integral * dx / 3.0_real64

    ! Normalise by the analytic vertical column density
    zenith_I = H_SCALE * exp(-a / H_SCALE)
    am = integral / zenith_I
  end function air_mass

end program air_mass_program

