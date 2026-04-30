!
program Currency
implicit none

! Store all money amounts in units of 1/10 Cent. (Cents only can result in rounding errors in Tax)
! Store Tax rate in PPM not in % for controlled, sufficient precision in integer calculation
!
! Use integer(kind=16) for internal represenation. This can carry up to 38 digits which
! gives a pretty amount of money, enough for most purposes.
! To display an amount V of money in terms of real xxx.yy $ rounded to nearest full cent,
!   divide the V by moneyFactor to  give the full Dollars, and
!   calculate Cents as nearest Integer  nint ( mod (V,moneyFactor) / CentFactor)
! Similarly, we represent  Tax percentage in units of ppm, again using Integerr(kind=16)
! To obtain the Tax, multiply value V with TaxPPM, then divide by PPMFactor

! Define constants here to avoid magic numbers within code
integer, parameter                  :: int_kind = 16          ! Will not work with smaller int_kind
integer, parameter                  :: float_kind = 8

integer, parameter                  :: moneyFactor = 1000
real(kind=float_kind)               :: CentFactor = 10.0
integer (kind=int_kind), parameter  :: PPMFactor = 1000000   ! 1 ppm = 1/1000000
integer (kind=int_kind), parameter  :: percentToPPM = 10000   ! 1 % = 10000 ppm

integer (kind=int_kind)       :: N_Hamburgers
integer (kind=int_kind)       :: N_Milkshake
integer (kind=int_kind)       :: Price_Hamburger
integer (kind=int_kind)       :: Price_Milkshake
integer (kind=int_kind)       :: Tax_Rate_PPM
integer (kind=int_kind)       :: Price_AllHamburgers, Price_AllMilkshakes, PriceBeforeTax, Tax, TotalWithTax

! Amounts, Prices and Tax Rate as in Task description
N_Hamburgers    = 4000000000000000_int_kind   ! pure number
N_Milkshake     = 2                           ! pure number
Price_Hamburger = nint (5.50 * MoneyFactor)   ! $ 5.50 in 1/10 cent, see above
Price_Milkshake = nint(2.86*MoneyFactor)      ! $2.86 in 1/10 cent
Tax_rate_PPM    = nint (7.65*percentToPPM)    ! 7.65% converted to ppm

! Very elementary math, additions and multiplication by integer values are exact unless overflow ocurs
Price_AllHamburgers =  N_Hamburgers *  Price_Hamburger
Price_AllMilkshakes =  N_Milkshake * Price_Milkshake
PriceBeforeTax = Price_AllHamburgers + Price_AllMilkshakes

! Multiplication by (percentage value * percentToPPM (=10000))
! and subsequent division by PPMFactor (=1000000) cuts off
! less than 0.1 cents from the exact result
!
Tax =   (Tax_rate_PPM *  PriceBeforeTax) / PPMFactor

! Addition is exact again.
TotalWithTax = PriceBeforeTax + Tax

! Display the results rounded to closest Dollar amount values
! with 2 decimal digits
!
! Spacing selected to display the expected result.
! More general solution for pretty-print required.
!
call printAsDollars ('Hamburgers            : $ ', Price_AllHamburgers)
call printAsDollars ('Milk Shakes           : $                 ', Price_AllMilkshakes)
call printAsDollars ('Total Price Before Tax: $ ', PriceBeforeTax)
call printAsDollars ('Tax                   : $  ', Tax)
call printAsDollars ('Total                 : $ ', TotalWithTax)

contains


  subroutine printAsDollars (text, amount)

  character (len=*), intent(in) :: text
  integer (kind = int_kind)  :: amount

  integer (kind = int_kind) :: fullDollars, Cents

  fullDollars = amount / moneyFactor
  Cents =  nint (mod (amount, moneyFactor)/CentFactor)
  ! rounding with nint() might result in exactly 100 cents, which is 1 Dollar.
  if (Cents .eq. 100) then
    fullDollars = fullDollars + 1
    Cents = 0
  endif
  write (6,'(A, i0,".",i2.2)') text, fullDollars, Cents
  end subroutine printAsDollars


end program Currency
