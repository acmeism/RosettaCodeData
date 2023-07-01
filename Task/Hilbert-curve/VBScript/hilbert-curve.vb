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
     if ori<0 then ori = ori+pi*2
   end sub
   public sub lt(i):
     ori=(ori + i*iang)
     if ori>(pi*2) then ori=ori-pi*2
   end sub

   public sub bw(l)
      x= x+ cos(ori+pi)*l*incr
      y= y+ sin(ori+pi)*l*incr
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

sub hilb (n,a)
if n=0 then exit sub
x.rt a
hilb n-1,-a: x.fw 1:x.lt a: Hilb n - 1,a
x.fw 1
hilb n-1,a : x.lt a: x.fw 1: Hilb n - 1,-a
x.rt a
end sub


dim x
set x=new turtle
x.iangle=90
x.orient=0
x.incr=5
x.x=100:x.y=700
'star5
hilb 7,1
set x=nothing
