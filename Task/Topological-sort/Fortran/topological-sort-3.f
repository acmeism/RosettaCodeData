subroutine tsort(nl,nd,idep,iord,no)

  implicit none

  integer,intent(in) :: nl
  integer,intent(in) :: nd
  integer,dimension(nd,2),intent(in) :: idep
  integer,dimension(nl),intent(out) :: iord
  integer,intent(out) :: no

  integer :: i,j,k,il,ir,ipl,ipr,ipos(nl)

  do i=1,nl
    iord(i)=i
    ipos(i)=i
  end do
  k=1
  do
    j=k
    k=nl+1
    do i=1,nd
      il=idep(i,1)
      ir=idep(i,2)
      ipl=ipos(il)
      ipr=ipos(ir)
      if (il==ir .or. ipl>=k .or. ipl<j .or. ipr<j) cycle
      k=k-1
      ipos(iord(k))=ipl
      ipos(il)=k
      iord(ipl)=iord(k)
      iord(k)=il
    end do
    if (k<=j) exit
  end do
  no=j-1

end subroutine tsort
