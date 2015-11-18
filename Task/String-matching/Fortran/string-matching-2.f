!-----------------------------------------------------------------------
!Main program string_matching
!-----------------------------------------------------------------------
program    string_matching
   implicit none
   character(len=*), parameter :: fmt= '(I0)'
   write(*,fmt) starts("this","is")
   write(*,fmt) starts("theory","the")
   write(*,fmt) has("bananas","an")
   write(*,fmt) ends("banana","an")
   write(*,fmt) ends("banana","na")
   write(*,fmt) ends("brief","much longer")

 contains
   !     Determining if the first string starts with second string
   function  starts(string1, string2) result(answer)
      implicit none
      character(len=*), intent(in) :: string1
      character(len=*), intent(in) :: string2
      integer :: answer
      answer = 0
      if(len(string2)>len(string1)) return
      if(string1(1:len(string2))==string2) answer = 1
   end function starts
   !     Determining if the first string contains the second string at any location
   function  has(string1, string2) result(answer)
      implicit none
      character(len=*), intent(in) :: string1
      character(len=*), intent(in) :: string2
      character(len=:),allocatable :: temp
      integer :: answer, add
      character(len=*), parameter :: fmt= '(A6,X,I0)'
      answer = 0
      add = 0
      if(len(string2)>len(string1)) return
      answer = index(string1, string2)
      if(answer==0) return
      !     Print the location of the match for part 2
      write(*,fmt) " at ", answer
      !     Handle multiple occurrences of a string for part 2.
      add = answer
      temp = string1(answer+1:)
      do while(answer>0)
         answer = index(temp, string2)
         add = add + answer
         if(answer>0) write(*,fmt) " at ", add
         !          deallocate(temp)
         temp = string1(add+1:) ! auto reallocation
      enddo
      answer = 1
   end function has
   !     Determining if the first string ends with the second string
   function  ends(string1, string2) result(answer)
      implicit none
      character(len=*), intent(in) :: string1
      character(len=*), intent(in) :: string2
      integer :: answer
      answer = 0
      if(len(string2)>len(string1)) return
      if(string1(len(string1)-len(string2)+1:)==string2) answer = 1
   end function ends
end program string_matching
