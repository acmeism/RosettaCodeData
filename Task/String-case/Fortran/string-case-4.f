module uplow
   implicit none
   character(len=26), parameter, private :: low  = "abcdefghijklmnopqrstuvwxyz"
   character(len=26), parameter, private :: high = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
contains

   function to_upper(s) result(t)
      ! returns upper case of s
      implicit none
      character(len=*), intent(in) :: s
      character(len=len(s))        :: t

      character(len=1), save       :: convtable(0:255)
      logical, save                :: first = .true.
      integer                      :: i

      if(first) then
         do i=0,255
            convtable(i) = char(i)
         enddo
         do i=1,len(low)
            convtable(iachar(low(i:i))) = char(iachar(high(i:i)))
         enddo
         first = .false.
      endif

      t = s

      do i=1,len_trim(s)
         t(i:i) = convtable(iachar(s(i:i)))
      enddo

   end function to_upper

   function to_lower(s) result(t)
      ! returns lower case of s
      implicit none
      character(len=*), intent(in) :: s
      character(len=len(s))        :: t

      character(len=1), save :: convtable(0:255)
      logical, save          :: first = .true.
      integer                :: i

      if(first) then
         do i=0,255
            convtable(i) = char(i)
         enddo
         do i = 1,len(low)
            convtable(iachar(high(i:i))) = char(iachar(low(i:i)))
         enddo
         first = .false.
      endif

      t = s

      do i=1,len_trim(s)
         t(i:i) = convtable(iachar(s(i:i)))
      enddo

   end function to_lower


end module uplow


program doit
   use uplow
   character(len=40) :: s

   s = "abcdxyz ZXYDCBA _!@"
   print *,"original: ",'[',s,']'
   print *,"to_upper: ",'[',to_upper(s),']'
   print *,"to_lower: ",'[',to_lower(s),']'

end program doit
