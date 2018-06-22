! This is a fortran95 implementation of the game of tic-tac-toe.
! - Objective was to use less than 100 lines.
! - No attention has been devoted to efficiency.
! - Indentation by findent: https://sourceforge.net/projects/findent/
! - This is free software, use as you like at own risk.
! - Compile: gfortran -o tictactoe tictactoe.f90
! - Run: ./tictactoe
! Comments to: wvermin at gmail dot com
module tic
   implicit none
   integer :: b(9)
contains
   logical function iswin(p)
      integer,intent(in) :: p
      iswin = &
         all(b([1,2,3])==p).or.all(b([4,5,6])==p).or.all(b([7,8,9])==p).or.&
         all(b([1,4,7])==p).or.all(b([2,5,8])==p).or.all(b([3,6,9])==p).or.&
         all(b([1,5,9])==p).or.all(b([3,5,7])==p)
   end function iswin
   subroutine printb(mes)
      character(len=*) :: mes
      integer          :: i,j
      character        :: s(0:2) = ['.','X','O']
      print "(3a3,'   ',3i3)",(s(b(3*i+1:3*i+3)),(j,j=3*i+1,3*i+3),i=0,2)
      if(mes /= ' ') print "(/,a)",mes
   end subroutine printb
   integer recursive function minmax(player,bestm) result(bestv)
      integer :: player,bestm,move,v,bm,win=1000,inf=100000
      real    :: x
      if (all(b .ne. 0)) then
         bestv = 0
      else
         bestv = -inf
         do move=1,9
            if (b(move) == 0) then
               b(move) = player
               if (iswin(player)) then
                  v = win
               else
                  call random_number(x)
                  v = -minmax(3-player,bm) - int(10*x)
               endif
               if (v > bestv) then
                  bestv = v
                  bestm = move
               endif
               b(move) = 0
               if (v == win) exit
            endif
         enddo
      endif
   end function minmax
end module tic
program tictactoe
   ! computer: player=1, user: player=2
   use tic
   implicit none
   integer :: move,ios,v,bestmove,ply,player=2,k,values(8)
   integer,allocatable :: seed(:)
   call date_and_time(values=values)
   call random_seed(size=k)
   allocate(seed(k))
   seed = values(8)+1000*values(7)+60*1000*values(6)+60*60*1000*values(5)
   call random_seed(put=seed)
   mainloop: do
      b = 0
      call printb('You have O, I have X. You enter 0: game ends.')
      plyloop: do ply=0,4
         if (player == 2 .or. ply >0 ) then  ! user move
            write(*,"(/,a)",advance='no'),'Your move? (0..9) '
            getloop: do
               readloop: do
                  read (*,*,iostat=ios),move
                  if (ios == 0 .and. move  >= 0 .and. move <= 9) exit readloop
                  write(*,"(a)",advance='no'),'huh? Try again (0..9): '
               enddo readloop
               if (  move  == 0) exit mainloop
               if (b(move) == 0) exit getloop
               write(*,"(a)",advance='no'),'Already occupied, again (0..9): '
            enddo getloop
            b(move) = 2
            if(iswin(2)) then   ! this should not happen
               call printb('***** You win *****')
               exit plyloop
            endif
         endif
         v = minmax(1,bestmove)   ! computer move
         b(bestmove) = 1
         if(iswin(1)) then
            call printb('***** I win *****')
            exit plyloop
         endif
         write(*,"(/,a,i3)"), 'My move: ',bestmove
         call printb(' ')
      enddo plyloop
      if(ply == 5) write(*,"('***** Draw *****',/)")
      player = 3-player
   enddo mainloop
end program
