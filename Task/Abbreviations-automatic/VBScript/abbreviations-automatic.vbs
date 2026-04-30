sub print(s) wscript.stdout.writeline s   :end sub

set d=createobject("Scripting.Dictionary")
set fso=createobject("Scripting.Filesystemobject")

const fn="weekdays_ansi.txt"
sfn=WScript.ScriptFullName
sfn= Left(sfn, InStrRev(sfn, "\"))
set f=fso.opentextfile(sfn & fn,1)

while not f.atendofstream
  s=f.readline
  if s=vbNullString then
	   print " "
	else
    a=split(trim(s)," ")
    for abrlen=1 to 14
      d.removeall
      for wd=0 to 6
        k=left(a(wd),abrlen)
        if d.exists(k) then
          exit for
        else
          d.add k,""
        end if
      next  'wd
      if wd>6 then exit for
    next 'abrlen
	  b=right("  " & abrlen,2)
	  for wd=0 to 6
       b=b &" "& left(a(wd),abrlen)
    next
    print b
  end if	
wend  'line
f.close
