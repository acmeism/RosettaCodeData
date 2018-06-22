/* REXX ***************************************************************
* Copy all files *.txt to *.rpl
* replacing all occurrences of old by new
* Execute in the directory containing the files to be processed
* 16.01.2013 Walter Pachl
*                         ...if file names contain blanks
**********************************************************************/
Parse Arg a
If a='?' Then Do
  Do i=2 To 5
    Say substr(sourceline(i),3)
    End
  Exit
  End
'dir *.rpl'
Say 'May I erase *.rpl?'
Parse Upper Pull answer
If answer='Y' | answer='J' Then
  'erase *.rpl'
Else Do
  Say 'Giving up..'
  Exit
  End
old='Goodbye London!'
new='Hello New York!'
dir='dir.dir'
'dir *.* >' dir
Do While lines(dir)>0
  Parse Value linein(dir) With 37 f
  Select
    When f='' |,
         left(f,1)='.' |,
         pos(' Bytes',f)>0 Then Iterate
    When right(f,4)='.txt' Then
      Call replace
    Otherwise
      Say left(f,50) 'not eligible for replacing'
    End
  End
Exit

replace:
/* REXX ***************************************************************
* Copy a file fn.txt to fn.rpl
* replacing all occurrences of old by new
**********************************************************************/
oid=fn(f)'.rpl'
cnt.=0
Do ii=1 By 1 While lines(f)>0
  l=linein(f)
  ol=repl(l,new,old)
  Call lineout oid,ol
  End
Call lineout f
Call lineout oid
Select
  When cnt.0changes=0 Then Do
    'erase' oid
    Say left(f,50) 'no changes'
    End
  When cnt.0changes=1 Then
    Say left(f,50) '1 change'
  Otherwise
    Say left(f '->' oid,50) cnt.0changes 'changes'
  End
Return

fn: Procedure
/* REXX ***************************************************************
* Get the file name of a file id
**********************************************************************/
parse Arg fid
Parse Var fid fn '.' ft
Return fn

repl: Procedure Expose cnt.
/* REXX ***************************************************************
* Replace an old string by a new one
**********************************************************************/
  Parse Arg s,new,old
  ol=''
  Do Until p=0
    p=pos(old,s)
    If p>0 Then Do
      ol=ol||left(s,p-1)||new
      s=substr(s,p+length(old))
      cnt.0changes=cnt.0changes+1
      End
    Else
      ol=ol||s
    End
  Return ol
