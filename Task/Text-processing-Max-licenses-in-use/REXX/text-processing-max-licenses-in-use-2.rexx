/* REXX **************************************************************
* 19.11.2012 Walter Pachl transscribed from PL/I
*                         and dual-coded (for PC (Windows) and TSO)
**********************************************************************/
Parse Source source
call time 'R'
Say source
If left(source,7)='Windows' Then Do
  fid='mlijobs.txt'
  Do i=1 By 1 While lines(fid)>0
    l.i=linein(fid)
    End
  l.0=i-1
  End
Else Do
  "ALLOC FI(IN) DA(MLIJOBS.TEXT) SHR REUSE"
  'EXECIO * DISKR IN (STEM L. FINIS'
  'FREE FI(IN)'
  End
store.0=0
max_nout=0
nout    =0
cnt=0
cnt.=0
do i=1 To l.0
  line=l.i
  Parse Var line 9 inout +3
  Select
    When inout='OUT' then nout = nout+1;
    When inout='IN'  then nout = nout-1;
    Otherwise Iterate
    End
  cnt.nout=cnt.nout+1
  cnt=cnt+1
  if nout = max_nout then
    Call store line
  if nout > max_nout then Do
    max_nout=nout
    drop store.
    store.0=0
    Call store
    end;
  end;

Say 'The maximum number of licences taken out = ' max_nout
Do i=1 to store.0
  k=pos('@',store.i)
  Say 'It occurred at 'substr(store.i,k+1)
  End
limit=5
Do nout=0 To max_nout
  If nout=limit+1 Then Say '.........'
  If nout<=limit | nout>=max_nout-limit Then
    Say right(cnt.nout,5) right(nout,3)
  End
Say right(cnt,5) 'Jobs'
Say time('E') 'seconds (elapsed)'
Exit

store:
  z=store.0+1
  store.z=line
  store.0=z
  Return
