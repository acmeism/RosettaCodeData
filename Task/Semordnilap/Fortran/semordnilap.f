!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Sun May 19 21:50:08
!
!a=./F && make $a && $a < unixdict.txt
!f95 -Wall -ffree-form F.F -o F
! 5 of          158 semordnilaps
!yaw
!room
!xi
!tim
!nova
!
!
!Compilation finished at Sun May 19 21:50:08
!
!
!
!
!                       unixdict.txt information
! wc -l unixdict.txt                                         #--> 25104                    25 thousand entries
! gawk 'length(a)<length($0){a=$0}END{print a}' unixdict.txt #--> electroencephalography   longest word has 22 characters
! gawk '/[A-Z]/{++a}END{print a}' unixdict.txt               #--> <empty>                  the dictionary is lower case
! sort unixdict.txt | cmp - unixdict.txt                     #--> - unixdict.txt differ: byte 45, line 12
!                                                                                          the dictionary is unsorted
!     mmmmm the dictionary is sorted, according to subroutine bs.  There's something about the ampersands within unixdict.txt I misunderstand.

program Semordnilap
  implicit none
  integer :: i, ios, words, swords
  character(len=24), dimension(32768) :: dictionary, backword
  real, dimension(5) :: harvest
  ! read the dictionary
  open(7,file='unixdict.txt')
  do words = 1, 32768
    read(7, '(a)', iostat = ios) dictionary(words)
    if (ios .ne. 0) exit
  enddo
  close(7)
  if (iachar(dictionary(words)(1:1)) .eq. 0) words = words-1
  ! sort the dictionary
  call bs(dictionary, words)
  !do i = 1, words
  !  write(6,*) dictionary(i)(1:len_trim(dictionary(i))) ! with which we determine the dictionary was ordered
  !enddo
  swords = 0
  do i = 1, words
    call reverse(dictionary(i), backword(swords+1))
    if ((binary_search(dictionary, words, backword(swords+1))) &      !     the reversed word is in the dictionary
      .and. (.not. binary_search(backword, swords, dictionary(i))) &  ! and it's new
      .and. (dictionary(i) .ne. backword(swords+1))) then             ! and it's not a palindrome
      swords = swords + 1
      call bs(backword, swords)
    endif
  enddo
  call random_number(harvest)
  call reverse('spalindromes', backword(swords+1))
  write(6, *) '5 of ', swords, backword(swords+1)
  write(6,'(5(a/))') (backword(1+int(harvest(i)*(swords-2))), i=1,5)

contains

  subroutine reverse(inp, outp)
    character(len=*), intent(in) :: inp
    character(len=*), intent(inout) :: outp
    integer :: k, L
    L = len_trim(inp)
    do k = 1, L
      outp(L+1-k:L+1-k) = inp(k:k)
    enddo
    do k = L+1, len(outp)
      outp(k:k) = ' '
    enddo
  end subroutine reverse

  subroutine bs(a, n) ! ok, despite having claimed that bubble sort should be unceremoniously buried, I'll use it anyway because I expect the dictionary is nearly ordered.  It's also not a terrible sort for less than 5 items.
    ! Please note, I tested bs using unixdict.txt randomized with sort --random .
    character(len=*),dimension(*),intent(inout) :: a
    integer, intent(in) :: n
    integer :: i, j, k
    logical :: done
    character(len=1) :: t
    do i=n-1, 1, -1
      done = .true.
      do j=1, i
        if (a(j+1) .lt. a(j)) then
          done = .false.
          do k = 1, max(len_trim(a(j+1)), len_trim(a(j)))
            t = a(j+1)(k:k)
            a(j+1)(k:k) = a(j)(k:k)
            a(j)(k:k) = t(1:1)
          enddo
        endif
      enddo
      if (done) return
    enddo
  end subroutine bs

  logical function binary_search(source, n, target)
    character(len=*),dimension(*),intent(in) :: source
    character(len=*),intent(in) :: target
    integer, intent(in) :: n
    integer :: a,m,z
    a = 1
    z = n
    do while (a .lt. z)
      m = a + (z - a) / 2
      if (target .lt. source(m)) then
        z = m-1
      else
        if (m .eq. a) exit
        a = m
      endif
    enddo
    binary_search = (target .eq. source(a)) .or. (target .eq. source(z))
  end function binary_search

end program Semordnilap
