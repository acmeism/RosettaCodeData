/* REXX ---------------------------------------------------------------
* 13.07.2014 Walter Pachl translated from PL/I
*--------------------------------------------------------------------*/
alist='999 888 777 1 5 13 15 17 19 21 5'
Parse Var alist lo hi .
Do i=1 By 1 While alist<>''
  Parse Var alist a.i alist;
  lo=min(lo,a.i)
  hi=max(hi,a.i)
  End
a.0=i-1

Call show 'before count_sort'
Call count_sort
Call show 'after count_sort'
Exit

count_sort: procedure Expose a. lo hi
  t.=0
  do i=1 to a.0
    j=a.i
    t.j=t.j+1
    end
  k=1
  do i=lo to hi
    if t.i<>0 then Do
      do j=1 to t.i
        a.k=i
        k=k+1
        end
      end
    end
  Return

show: Procedure Expose a.
Parse Arg head
Say head
ol=''
Do i=1 To a.0
  ol=ol right(a.i,3)
  End
Say ol
Return
