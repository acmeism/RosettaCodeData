 character*40 words
 character*40 reversed
 logical inblank
 ierr=0
 read (5,fmt="(a)",iostat=ierr)words
 do while (ierr.eq.0)
 inblank=.true.
 ipos=1
 do i=40,1,-1
   if(words(i:i).ne.' '.and.inblank) then
     last=i
     inblank=.false.
     end if
    if(.not.inblank.and.words(i:i).eq.' ') then
      reversed(ipos:ipos+last-i)=words(i+1:last)
      ipos=ipos+last-i+1
      inblank=.true.
      end if
     if(.not.inblank.and.i.eq.1) then
       reversed(ipos:ipos+last-1)=words(1:last)
       ipos=ipos+last
       end if
   end do
 print *,words,'=> ',reversed(1:ipos-1)
 read (5,fmt="(a)",iostat=ierr)words
 end do
 end
