      module kmp_mod
      use iso_fortran_env
      implicit none
      private
      public :: kmpsearch
      contains
        !This subroutine creates the "fail" table used for the KMP algorithm
      pure subroutine createtable(pattern,patlen,table)

      implicit none
!
! Dummy arguments
!
      integer :: patlen
      character(*) :: pattern
      integer , dimension(:) :: table
      intent (in) patlen , pattern
      intent (inout) table
!
! Local variables
!
      integer :: counter
      integer :: i
      integer :: j
!*Code
      counter=2
      i=1
      j=0
            !Determine the table/fail value for each letter in the pattern
      do i=1 , patlen
         j=i
         do
            ! If j is equal to zero, then there is no offset/fail value required. Therefore, just set the fail value to 0
            if( j==1 )then
               table(counter)=1
               counter=counter+1
               exit
            end if

            ! If a match is made, the fail value can be imcremented by one (based off the fail value of the previous character in the pattern)
            if( pattern(table(j):table(j))==pattern(i:i) )then
               table(counter)=table(j)+1
               counter=counter+1
               exit
            end if

            ! If neither if statement is true, restart the fail value counter
            j=table(j)
         end do
      end do
      end subroutine createtable

      ! This subroutine executes the string search using the KMP algorithm (fail table)
      pure function kmpsearch(pattern,patlen,line,linelen)              &
                            & result(foundmatch)

      implicit none
!
! Dummy arguments
!
      character(*) :: line
      integer :: linelen
      integer :: patlen
      character(*) :: pattern
      intent (in) line , linelen , patlen , pattern
!
! Local variables
!
      integer :: foundmatch
      integer :: indice
      integer :: match
      integer , dimension(256) :: table
!*Code
      if( (patlen==0) .or. (linelen==0) .or. (linelen<patlen) )then
         foundmatch=-1
         return
      end if

      indice=1
      match=0
      foundmatch=-1
      call createtable(pattern,patlen,table)
            !Search the entire string
      do while ( indice+match<=linelen )
         if( match+1<patlen+1 )then

            ! If the character matches the character we are expecting (based on where in the pattern we have already matched characters with) increment the match indice
            if( line(indice+match:indice+match)==pattern(match+1:match+1) )then
               match=match+1

               ! If the match indice is equal to the length of the pattern, that means we have matched the entire pattern
               if( match==patlen )then
                  foundmatch=indice            !-1
                  exit !Found
               end if
                    !Look at the table to determine what indice to check next
            ! If no match was made on the first letter of the pattern, then just increment the indice counter by one and check again
            else if( match==0 )then
               indice=indice+1
            ! Check how many characters to skip ahead (the point of the KMP algorithm)
            else
               indice=indice+match+1-table(match+1)
               match=table(match+1)-1
            end if
         ! If no match was made after scanning the length of the pattern, need increment the indice counter and check again
         else if( match==0 )then
            indice=indice+1                !Not even a partial match, try next character
         else             !Check how many characters to skip ahead (the point of the KMP algorithm)
            indice=indice+match+1-table(match+1)
            match=table(match+1)-1
         end if
      end do
!       'No match found'
      return
      end function kmpsearch
      end module kmp_mod
