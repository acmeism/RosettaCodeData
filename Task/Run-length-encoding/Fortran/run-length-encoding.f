program RLE
  implicit none

  integer, parameter :: bufsize = 100   ! Sets maximum size of coded and decoded strings, adjust as necessary
  character(bufsize) :: teststr = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"
  character(bufsize) :: codedstr = "", decodedstr = ""

  call Encode(teststr, codedstr)
  write(*,"(a)") trim(codedstr)
  call Decode(codedstr, decodedstr)
  write(*,"(a)") trim(decodedstr)

contains

subroutine Encode(instr, outstr)
  character(*), intent(in)  :: instr
  character(*), intent(out) :: outstr
  character(8) :: tempstr = ""
  character(26) :: validchars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  integer :: a, b, c, i

  if(verify(trim(instr), validchars) /= 0) then
    outstr = "Invalid input"
    return
  end if
  outstr = ""
  c = 1
  a = iachar(instr(1:1))
  do i = 2, len(trim(instr))
    b = iachar(instr(i:i))
    if(a == b) then
      c = c + 1
    else
      write(tempstr, "(i0)") c
      outstr = trim(outstr) // trim(tempstr) // achar(a)
      a = b
      c = 1
    end if
  end do
  write(tempstr, "(i0)") c
  outstr = trim(outstr) // trim(tempstr) // achar(b)
end subroutine

subroutine Decode(instr, outstr)
  character(*), intent(in)  :: instr
  character(*), intent(out) :: outstr
  character(26) :: validchars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  integer :: startn, endn, n

  outstr = ""
  startn = 1
  do while(startn < len(trim(instr)))
    endn = scan(instr(startn:), validchars) + startn - 1
    read(instr(startn:endn-1), "(i8)") n
    outstr = trim(outstr) // repeat(instr(endn:endn), n)
    startn = endn + 1
  end do
end subroutine
end program
