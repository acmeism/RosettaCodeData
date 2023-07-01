! game 21 - an example in modern fortran language for rosseta code.

subroutine ai
  common itotal, igoal
  if (itotal .lt. igoal) then
    move = 1
    do i = 1, 3
      if (mod(itotal + i - 1 , 4) .eq. 0) then
        move = i
      end if
    end do
    do i = 1, 3
      if (itotal + i .eq. igoal) then
        move = i
      end if
    end do
    print *, "      ai  ", itotal + move, " = ", itotal, " + ", move
    itotal = itotal + move
    if (itotal .eq. igoal) then
      print *, ""
      print *, "the winner is ai"
      print *, ""
    end if
  end if
end subroutine ai

subroutine human
  common itotal, igoal
  print *, ""
  do while (.true.)
    if (itotal + 1 .eq. igoal) then
      print *, "enter 1 (or 0 to exit): "
    else if (itotal + 2 .eq. igoal) then
      print *, "enter 1 or 2 (or 0 to exit): "
    else
      print *, "enter 1 or 2 or 3 (or 0 to exit)"
    end if
    read(*,*) move
    if (move .eq. 0) then
      stop
    else if (move .ge. 1 .and. move .le. 3 .and. move + itotal .le. igoal) then
      print *, "   human  ", itotal + move, " = ", itotal, " + ", move
      itotal = itotal + move
      if (itotal .eq. igoal) then
        print *, ""
        print *, "the winner is human"
        print *, ""
      end if
      return
    else
      print *, "a bad choice"
    end if
  end do
end subroutine human

program main
  common itotal, igoal
  print *,"game 21 - an example in fortran iv language for rosseta code."
  print *,""
  print *,"21 is a two player game, the game is played by choosing a number"
  print *,"(1, 2, or 3) to be added to the running total. the game is won"
  print *,"by the player whose chosen number causes the running total to reach"
  print *,"exactly 21. the running total starts at zero."
  print *,""
  i = irand(1)
  igoal = 21
  do while(.true.)
    print *, "---- new game ----"
    print *, ""
    print *, "the running total is currently zero."
    print *, ""
    itotal = 0
    if (mod(irand(0), 2) .eq. 0) then
      print *, "the first move is ai move."
      call ai
    else
      print *, "the first move is human move."
    end if
    print *, ""
    do while(itotal .lt. igoal)
      call human
      call ai
    end do
end do
end program main
