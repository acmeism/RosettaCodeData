! Find common directory path
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! U.B., January 2026
!=========================================================================================
program commonDirPath

implicit none

! The longest path string in these little examples has a length 31 characters.
! The test data listed in the task description has three path strings
integer, parameter :: longestP = 31, nStrings=3

! We handle the test data set listed in the task description, and some extra to cover more special cases
character (len=longestP) , dimension(nStrings) :: names
integer :: i

! expect /home/user1/tmp
! This is the test case in the task description
         !.........1.........2.........3.           ! gfortran does not accept differnt lengths here
names = ["/home/user1/tmp/coverage/test/ ",   &
         "/home/user1/tmp/covert/operator",   &
		     "/home/user1/tmp/coven/members  "   ]

! Print the used names, the expected common directory path, and the actual result
write (*, '(" Input:  ", A, 2(/, "         ",A))') (names(i),i=1,nStrings)
write (*, '(" expect: /home/user1/tmp")')
call printCommonDirPath (names, longestP, nStrings)

! expect /home/user2
! Special case: 1st path ends with '/', second does not. But both  describe the same path
         !.........1.........2.........3.           ! gfortran does not accept differnt lengths here
names = ['/home/user2/                   ',   &
         '/home/user2                    ',   &
         '/home/user2/bubu               ']
write (*, '(" Input:  ", A, 2(/, "         ",A))') (names(i),i=1,nStrings)
write (*, '(" expect: /home/user2")')
call printCommonDirPath (names, longestP, 3)

! expect /
! Special case: 1st character is the '/', all following text is diffent in all 3 names.
         !.........1.........2.........3.           ! gfortran does not accept differnt lengths here
names = ['/                              ',    &
         '/hugo/                         ',    &
         '/etc                           ']
write (*, '(" Input:  ", A, 2(/, "         ",A))') (names(i),i=1,nStrings)
write (*, '(" expect: /")' )
call printCommonDirPath (names, longestP, 3)

! expect nothing
! SPecial case: no common path
         !.........1.........2.........3.           ! gfortran does not accept differnt lengths here
names = ['/                              ',     &
         'hugo/                          ',     &
         '/etc                           ']
write (*, '(" Input:  ", A, 2(/, "         ",A))') (names(i),i=1,nStrings)
print *, 'expect: (No common path)'
call printCommonDirPath (names, longestP, 3)


contains

! =====================================================================
! Find common directory path in the  of path names and print the result
! =====================================================================
subroutine printCommonDirPath (argNames, argLen, argN)

integer , intent(in) :: argLen, argN      ! Path length, and  array size
character (len=argLen), dimension(argN), intent(inout) :: argNames
integer :: commonLength, ii

commonLength = calcCommonLength(argNames, argLen, argN)

if (commonLength .gt. 0) then
  write (*,'(" Result: ", A,/)')   names(1)(:commonLength)
else
  write (*, '(" Result: (No common Path)",/)')
endif

end subroutine printCommonDirPath


! =====================================================================================
! Find common directory path in the  of path names and return the length of the result.
! ======================================================================================
function calcCommonLength (argNames, argLen, argN) result (cl)

integer , intent(in) :: argLen, argN
character (len=argLen), dimension(argN), intent(inout) :: argNames
integer :: cl

integer, dimension(argN) :: lengths
integer :: shortestLength
character, parameter :: direcDelim = '/'
integer :: ii, jj, kk

! Find lengths of all path strings, memoize shortest
shortestLength = longestP ! initialize largest possible value to find minimum
do ii=1, argN
  lengths(ii) = len_trim (argNames(ii))
  if (lengths(ii) .gt.1 .and. argNames(ii)(lengths(ii):lengths(ii)) .ne. direcDelim) then
    ! This path is not only '/' but the string does not end with '/': Pretend it does.
    lengths(ii) = lengths(ii) + 1
    argNames(ii)(lengths(ii):lengths(ii)) = direcDelim
  end if
  shortestLength = min (shortestLength, lengths(ii))
end do

outer: do
  kk = 1                            ! to be set 0 upon first mismatch
  inner: do ii=2, argN              ! compare 2nd ff with 1st string
    if (argNames (ii)(:shortestLength) .ne. argNames(1)(:shortestLength))  then     ! Mismatch found
      ! Not all paths up to the commonm minimum length are equal.
      kk = 0
      ! Special case: shortest path has only 1 character, and at least 1 other path is different
      if (shortestLength .eq. 1) then
        cl = 0
        exit outer
      end if

      ! Standard case:
      ! Go back to ne next earlier delimiter and compare the paths up to there
      do jj=shortestLength-1, 1, -1
        if (argNames(1)(jj:jj) .eq. direcDelim) then
          shortestLength = jj
          exit inner                   ! but continue cycling outer
        endif
      end do
      ! here if no further delimiter found left of the previuos one.
      if (shortestLength .lt. 1 ) then
        cl = 0
        exit outer
      end if
      exit inner                        ! Quit comparing strings when 1st mismatch found
    endif                               ! Mismatch found
  enddo inner                           ! ENd loop comparing strings

  if (kk .eq. 1) then                   ! No mismatch found: finish.
    cl = max(shortestLength-1, 1)       ! forget about the last '/' unless its the only common character.
    exit outer                          ! All done.
  end if
enddo outer

end function calcCommonLength
end program commonDirPath
