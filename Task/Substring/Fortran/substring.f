program test_substring

  character (*), parameter :: string = 'The quick brown fox jumps over the lazy dog.'
  character (*), parameter :: substring = 'brown'
  character    , parameter :: c = 'q'
  integer      , parameter :: n = 5
  integer      , parameter :: m = 15
  integer                  :: i

! Display the substring starting from n characters in and of length m.
  write (*, '(a)') string (n : n + m - 1)
! Display the substring starting from n characters in, up to the end of the string.
  write (*, '(a)') string (n :)
! Display the whole string minus the last character.
  i = len (string) - 1
  write (*, '(a)') string (: i)
! Display the substring starting from a known character and of length m.
  i = index (string, c)
  write (*, '(a)') string (i : i + m - 1)
! Display the substring starting from a known substring and of length m.
  i = index (string, substring)
  write (*, '(a)') string (i : i + m - 1)

end program test_substring
