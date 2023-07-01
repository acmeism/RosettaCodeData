program test_max

  implicit none

  write (*, '(i0)') &
    & max (1, 2, 3)
  write (*, '(f3.1)') &
    & max (1.0, 2.0, 3.0)
  write (*, '(a)') &
    & max ('a', 'b', 'c')
  write (*, '(a)') &
    & max ('abc', 'bca', 'cab')
  write (*, '(i0, 2 (1x, i0))') &
    & max ([1, 8, 6], [7, 5, 3], [4, 2, 9])
  write (*, '(f3.1, 2 (1x, f3.1))') &
    & max ([1.0, 8.0, 6.0], [7.0, 5.0, 3.0], [4.0, 2.0, 9.0])
  write (*, '(a, 2 (1x, a))') &
    & max (['a', 'h', 'f'], ['g', 'e', 'c'], ['d', 'b', 'i'])
  write (*, '(a, 2 (1x, a))') &
    & max (['abc', 'hig', 'fde'], ['ghi', 'efd', 'cab'], ['def', 'bca', 'igh'])

end program test_max
