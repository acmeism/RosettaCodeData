'Sparkline

sub ensure_cscript()
if instrrev(ucase(WScript.FullName),"WSCRIPT.EXE")then
   createobject("wscript.shell").run "CSCRIPT //nologo """ &_
     WScript.ScriptFullName &"""" ,,0
   wscript.quit
 end if
end sub

class bargraph
  private bar,mn,mx,nn,cnt

  Private sub class_initialize()
     bar=chrw(&h2581)&chrw(&h2582)&chrw(&h2583)&chrw(&h2584)&chrw(&h2585)&_
     chrw(&h2586)&chrw(&h2587)&chrw(&h2588)
     nn=8
  end sub


  public function bg (s)
    a=split(replace(replace(s,","," "),"  "," ")," ")

    mn=999999:mx=-999999:cnt=ubound(a)+1
    for i=0 to ubound(a)
       a(i)=cdbl(trim(a(i)))
       if a(i)>mx then mx=a(i)
       if a(i)<mn then mn=a(i)
    next

    ss="Data:    "
    for i=0 to ubound(a) :ss=ss & right ("     "& a(i),6) :next

    ss=ss+vbcrlf + "sparkline: "

    for i=0 to ubound(a)
       x=scale(a(i))
       'wscript.echo mn,mx, a(i),x
       ss=ss & string(6,mid(bar,x,1))
    next
    bg=ss &vbcrlf & "min: "&mn & "  max: "& mx & _
      " cnt: "& ubound(a)+1 &vbcrlf
  end function

  private function scale(x)
    if x=<mn then
      scale=1
    elseif x>=mx then
      scale=nn
    else
      scale=int(nn* (x-mn)/(mx-mn)+1)
    end if
  end function

end class

ensure_cscript

set b=new bargraph
wscript.stdout.writeblanklines 2
wscript.echo b.bg("1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1")
wscript.echo b.bg("1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5")
wscript.echo b.bg("0, 1, 19, 20")
wscript.echo b.bg("0, 999, 4000, 4999, 7000, 7999")
set b=nothing

wscript.echo "If bars don't display correctly please set the the console " & _
"font to DejaVu Sans Mono or any other that has the bargrph characters" & _
vbcrlf

wscript.stdout.write "Press any key.." : wscript.stdin.read 1
