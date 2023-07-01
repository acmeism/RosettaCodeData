! Standard Fortran, should work with any modern compiler (tested gfortran 9)
! and ANSI supporting terminal (tested Linux, various terminals).
program coloured_terminal_text
  use, intrinsic :: iso_fortran_env, only: ERROR_UNIT
  implicit none

  ! Some parameters for our ANSI escape codes
  character(*), parameter :: esc = achar(27) ! Escape character.
  character(*), parameter :: reset = esc // '[0m' ! Terminates an ANSI code.
  ! Foreground(font) Colours
  character(*), parameter :: red     = esc // '[31m'
  character(*), parameter :: green   = esc // '[32m'
  character(*), parameter :: yellow  = esc // '[33m'
  character(*), parameter :: blue    = esc // '[34m'
  character(*), parameter :: magenta = esc // '[35m'
  character(*), parameter :: cyan    = esc // '[36m'
  character(*), parameter :: grey    = esc // '[90m' !Bright-Black
  ! One background colour
  character(*), parameter :: background_green = esc // '[42m'
  ! Some other formatting
  character(*), parameter :: bold = esc // '[1m'
  character(*), parameter :: bold_blink = esc // '[1;5m'

  ! Write to terminal (stderr, use OUTPUT_UNIT for stdout)
  write(ERROR_UNIT, '(a)') bold // 'Coloured words:' // reset
  write(ERROR_UNIT, '(4x, a)')       &
      red     // 'Red'     // reset, &
      green   // 'Green'   // reset, &
      yellow  // 'Yellow'  // reset, &
      blue    // 'Blue'    // reset, &
      magenta // 'Magenta' // reset, &
      cyan    // 'Cyan'    // reset, &
      grey    // 'Grey'    // reset
  write(ERROR_UNIT, '(a)') bold_blink // 'THE END ;-)' // reset

  write(ERROR_UNIT, '(a)') background_green // 'Bonus Round' // reset
end program coloured_terminal_text
