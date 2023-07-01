       module bm_str
       implicit none
       private
       public  ::  bmstr
!
! PARAMETER definitions
!
       integer , private , parameter  ::  NO_OF_CHARS = 256, SIZEX=256
       contains
       pure subroutine badcharheuristic(Str,M,Badchar)
       implicit none
! Dummy arguments
!
       integer  ::  M
       integer , dimension(NO_OF_CHARS)  ::  Badchar
       character(1) , dimension(M)  ::  Str
       intent (in) M , Str
       intent (out) Badchar
!
! Local variables
!
       integer  ::  i
! Code starts here
        Badchar(NO_OF_CHARS) = -1
       do i = 1 , M
           Badchar(iachar(Str(i))) = i
       enddo
       return
       end subroutine badcharheuristic

        function bmstr(Pat,M,Str,N) result(found)
       implicit none
!
! Dummy arguments
!
       integer  ::  M
       integer  ::  N
       character(len=m)   ::  Pat
       character(len=n)   ::  Str
       intent (in) M , N , Pat , Str
!
! Local variables
!
       integer , dimension(NO_OF_CHARS)  ::  badchar
       integer  ::  found
       integer  ::  i
       integer  ::  j
       integer  ::  s
! Code starts here
!
       found = -1
       if ( (M==0) .OR. (N==0) .OR. (M>N) ) return
       badchar = 0
       call badcharheuristic(Pat,M,badchar)
       i = 0
       s = 0
       do while ( s<=(N-M) )
           j = M
            do j = m,1,-1
               if((Pat(j:j) /= Str(s+j:s+j)) )exit ! Leave, the pattern doesn't match.
           enddo
           if ( j < 1 ) then ! Found, let's leave
               found = s + 1
               return
           endif
           i = badchar(iachar(Str(s+j:s+j)))
           s = s + MAX(1,j-i)
       enddo
       found = -1
       return
       end function bmstr
       end module bm_str
