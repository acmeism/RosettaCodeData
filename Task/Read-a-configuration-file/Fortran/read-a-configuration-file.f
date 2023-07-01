program readconfig
  implicit none
  integer, parameter    :: strlen = 100
  logical               :: needspeeling = .false., seedsremoved =.false.
  character(len=strlen) :: favouritefruit = "", fullname = "", fst, snd
  character(len=strlen), allocatable :: otherfamily(:), tmp(:)
  character(len=1000)   :: line
  integer               :: lun, stat,  j, j0, j1, ii = 1, z
  integer, parameter    :: state_begin=1, state_in_fst=2, state_in_sep=3

  open(newunit=lun, file="config.ini", status="old")

  do
    read(lun, "(a)", iostat=stat) line
    if (stat<0) exit
    if ((line(1:1) == "#") .or. &
        (line(1:1) == ";") .or. &
        (len_trim(line)==0)) then
      cycle
    end if
    z = state_begin
    do j = 1, len_trim(line)
      if (z == state_begin) then
        if (line(j:j)/=" ") then
          j0 = j
          z = state_in_fst
        end if
      elseif (z == state_in_fst) then
        if (index("= ",line(j:j))>0) then
          fst = lower(line(j0:j-1))
          z = state_in_sep
        end if
      elseif (z == state_in_sep) then
        if (index(" =",line(j:j)) == 0) then
          snd = line(j:)
          exit
        end if
      else
         stop "not possible to be here"
      end if
    end do
    if (z == state_in_fst) then
      fst = lower(line(j0:))
    elseif (z == state_begin) then
      cycle
    end if

    if (fst=="fullname") then
      read(snd,"(a)") fullname
    elseif (fst=="favouritefruit") then
      read(snd,"(a)") favouritefruit
    elseif (fst=="seedsremoved") then
      seedsremoved = .true.
    elseif (fst=="needspeeling") then
      needspeeling = .true.
    elseif (fst=="otherfamily") then
      j = 1; ii = 1
      do while (len_trim(snd(j:)) >0)
        j1  = index(snd(j:),",")
        if (j1==0) then
          j1 = len_trim(snd)
        else
          j1 = j + j1 - 2
        end if
        do
          if (j>len_trim(snd)) exit
          if (snd(j:j) /= " ") exit
          j = j +1
        end do
        allocate(tmp(ii))
        tmp(1:ii-1) = otherfamily
        call move_alloc(tmp, otherfamily)
        read(snd(j:j1),"(a)"), otherfamily(ii)
        j = j1 + 2
        ii = ii + 1
      end do
    else
      print *, "unknown option '"//trim(fst)//"'"; stop
    end if
  end do
  close(lun)

  print "(a,a)","fullname = ",       trim(fullname)
  print "(a,a)","favouritefruit = ", trim(favouritefruit)
  print "(a,l)","needspeeling = ",   needspeeling
  print "(a,l)","seedsremoved = ",   seedsremoved
  print "(a,*(a,:,', '))", "otherfamily = ", &
         (trim(otherfamily(j)), j=1,size(otherfamily))

contains

pure function lower (str) result (string)
    implicit none
    character(*), intent(In) :: str
    character(len(str))      :: string
    Integer :: ic, i

    character(26), parameter :: cap = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    character(26), parameter :: low = 'abcdefghijklmnopqrstuvwxyz'

    string = str
    do i = 1, len_trim(str)
        ic = index(cap, str(i:i))
        if (ic > 0) string(i:i) = low(ic:ic)
    end do
end function

end program
