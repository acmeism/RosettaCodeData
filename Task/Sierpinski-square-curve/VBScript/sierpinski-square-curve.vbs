option explicit
'outputs turtle graphics to svg file and opens it

const pi180= 0.01745329251994329576923690768489 ' pi/180
const pi=3.1415926535897932384626433832795 'pi
class turtle

   dim fso
   dim fn
   dim svg

   dim iang  'radians
   dim ori   'radians
   dim incr
   dim pdown
   dim clr
   dim x
   dim y

   public property let orient(n):ori = n*pi180 :end property
   public property let iangle(n):iang= n*pi180 :end property
   public sub pd() : pdown=true: end sub
   public sub pu()  :pdown=FALSE :end sub

   public sub rt(i)
     ori=ori - i*iang:
     'if ori<0 then ori = ori+pi*2
   end sub
   public sub lt(i):
     ori=(ori + i*iang)
     'if ori>(pi*2) then ori=ori-pi*2
   end sub

   public sub bw(l)
      x= x+ cos(ori+pi)*l*incr
      y= y+ sin(ori+pi)*l*incr
     ' ori=ori+pi '?????
   end sub

   public sub fw(l)
      dim x1,y1
      x1=x + cos(ori)*l*incr
      y1=y + sin(ori)*l*incr
      if pdown then line x,y,x1,y1
      x=x1:y=y1
   end sub

   Private Sub Class_Initialize()
      setlocale "us"
      initsvg
      x=400:y=400:incr=100
      ori=90*pi180
      iang=90*pi180
      clr=0
      pdown=true
   end sub

   Private Sub Class_Terminate()
      disply
   end sub

   private sub line (x,y,x1,y1)
      svg.WriteLine "<line x1=""" & x & """ y1= """& y & """ x2=""" & x1& """ y2=""" & y1 & """/>"
   end sub

   private sub disply()
       dim shell
       svg.WriteLine "</svg></body></html>"
       svg.close
       Set shell = CreateObject("Shell.Application")
       shell.ShellExecute fn,1,False
   end sub

   private sub initsvg()
     dim scriptpath
     Set fso = CreateObject ("Scripting.Filesystemobject")
     ScriptPath= Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\"))
     fn=Scriptpath & "SIERP.HTML"
     Set svg = fso.CreateTextFile(fn,True)
     if SVG IS nothing then wscript.echo "Can't create svg file" :vscript.quit
     svg.WriteLine "<!DOCTYPE html>" &vbcrlf & "<html>" &vbcrlf & "<head>"
     svg.writeline "<style>" & vbcrlf & "line {stroke:rgb(255,0,0);stroke-width:.5}" &vbcrlf &"</style>"
     svg.writeline "</head>"&vbcrlf & "<body>"
     svg.WriteLine "<svg xmlns=""http://www.w3.org/2000/svg"" width=""800"" height=""800"" viewBox=""0 0 800 800"">"
   end sub
end class

'to half.sierpinski :size :level
' if :level = 0 [forward :size stop]
' half.sierpinski :size :level - 1
' left 45
' forward :size * sqrt 2
' left 45
' half.sierpinski :size :level - 1
' right 90
' forward :size
' right 90
' half.sierpinski :size :level - 1
' left 45
' forward :size * sqrt 2
' left 45
' half.sierpinski :size :level - 1
'end
const raiz2=1.4142135623730950488016887242097
sub media_sierp (niv,sz)
   if niv=0 then x.fw sz: exit sub
   media_sierp niv-1,sz
   x.lt 1
   x.fw sz*raiz2
   x.lt 1
    media_sierp niv-1,sz
   x.rt 2
   x.fw sz
   x.rt 2
  media_sierp niv-1,sz
   x.lt 1
   x.fw sz*raiz2
   x.lt 1
    media_sierp niv-1,sz
end sub

'to sierpinski :size :level
' half.sierpinski :size :level
' right 90
' forward :size
' right 90
' half.sierpinski :size :level
' right 90
' forward :size
' right 90
'end

sub sierp(niv,sz)
   media_sierp niv,sz
   x.rt 2
   x.fw sz
   x.rt 2
   media_sierp niv,sz
   x.rt 2
   x.fw sz
   x.rt 2
end sub

dim x
set x=new turtle
x.iangle=45
x.orient=0
x.incr=1
x.x=100:x.y=270
'star5
sierp 5,4
set x=nothing
