/* REXX **************************************************************
* 21.11.2012 Walter Pachl transcribed from PL/I
**********************************************************************/
  Call time 'R'
  Say 'Verification that the first 40 FFR numbers and the first'
  Say '960 FFS numbers result in the integers 1 to 1000 only.'
  t.=0
  num.=''
  do i = 1 to 40
    j = ffr(i)
    if t.j then Say 'error, duplicate value at ' || i
    else t.j = 1
    num.i=j
    end
  nn=0
  Say time('E') 'seconds elapsed'
  Do i=1 To 3
    ol=''
    Do j=1 To 15
      nn=nn+1
      ol=ol right(num.nn,3)
      End
    Say ol
    End
  do i = 1 to 960
    j = ffs(i)
    if t.j then
      Say 'error, duplicate value at ' || i
    else t.j = 1
    end
  Do i=1 To 1000
    if t.i=0 Then
      Say i 'was not set'
    End
  If i>1000 Then
    Say 'passed test'
  Say time('E') 'seconds elapsed'
  Exit

 ffr: procedure Expose v.
   Parse Arg n
   v.= 0
   v.1 = 1
   if n = 1 then return 1
   r = 1
   do i = 2 to n
     do j = 2 to 2*n
       if v.j = 0 then leave
       end
     v.j = 1
     s = j
     r = r + s
     if r <= 2*n then v.r = 1
     end
   return r

 ffs: procedure Expose v.
   Parse Arg n
   v.= 0
   v.1 = 1
   if n = 1 then return 2
   r = 1
   do i = 1 to n
     do j = 2 to 2*n
       if v.j = 0 then leave
       end
     v.j = 1
     s = j
     r = r + s
     if r <= 2*n then v.r = 1
     end
   return s
