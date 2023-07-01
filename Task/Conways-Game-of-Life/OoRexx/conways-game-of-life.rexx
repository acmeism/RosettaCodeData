/* REXX ---------------------------------------------------------------
* 07.08.2014 Walter Pachl Conway's Game of life  graphical
* Input is a file containing the initial pattern.
* The compute area is extended when needed
*   (i.e., when cells are born outside the current compute area)
* When computing the pattern sequence is complete, the graphical
* output starts and continues until Cancel is pressed.
* 10.08.2014 WP fixed the output of what.txt
*--------------------------------------------------------------------*/
 Parse Arg what speed
 If what='?' Then Do
   Say 'Create a file containing the pattern to be processed'
   Say 'named somename.in (octagon.in such as this for the octagon):'
   Say '   **   '
   Say '  *  *  '
   Say ' *    * '
   Say '*      *'
   Say '*      *'
   Say ' *    * '
   Say '  *  *  '
   Say '   **   '
   Say 'Run the program by entering "rexx conlife somename [pause]"',
                                                 'on the command line.'
   Say '(pause is the amount of milliseconds between 2 pictures.',
                                                     'default is 1000)'
   Say 'A file somename.lst will be created.'
   Say 'Hereafter you will see the pattern''s development',
                                                     'in a new window.'
   Say 'Press the Cancel button to end the presentation.'
   Exit
   End
 Parse Version interpreter '_' level '('
 If interpreter<>'REXX-ooRexx' Then Do
   Say interpreter  level
   Say 'This program must be run with object Rexx.'
   Exit
   End
 If what='' Then what='octagon'
 If right(what,3)='.in' then
   what=left(what,length(what)-3)
 infile=what'.in'
 If lines(infile)=0 Then Do
   Say 'Input file' infile 'not found.'
   Say 'Enter conlife ? for help.'
   Exit
   End
 If speed='' Then
   speed=1000
 .local~myspeed=speed

 Call tl what
 --'type' what'.lst'

 .local~title=what
 array=.local~myarrayData
 d = .drawDlg~new
 if d~initCode <> 0 then do
    say 'The Draw dialog was not created correctly.  Aborting.'
    return d~initCode
 end
 d~execute("SHOWTOP")
 return 0

::requires "ooDialog.cls"

::class 'drawDlg' subclass UserDialog

::attribute interrupted unguarded

::method init
   expose walterFont

   forward class (super) continue
   -- colornames:
   --  1 dark red      7 light grey   13 red
   --  2 dark green    8 pale green   14 light green
   --  3 dark yellow   9 light blue   15 yellow
   --  4 dark blue    10 white        16 blue
   --  5 purple       11 grey         17 pink
   --  6 blue grey    12 dark grey    18 turquoise

   self~interrupted = .true

   -- Create a font to write the nice big letters and digits
   opts = .directory~new
   opts~weight = 700
   walterFont = self~createFontEx("Arial",14,opts)
   walterFont = self~createFontEx("Courier",18,opts)

   if \self~createcenter(200, 235,"Walter's Clock", , ,"System",14) then
      self~initCode = 1

::method defineDialog

   self~createPushButton(/*IDC_PB_DRAW*/100,  0,  0,240,200,"DISABLED NOTAB")  -- The drawing surface.

   self~createPushButton(IDCANCEL,160,220, 35, 12,,"&Cancel")

::method initDialog unguarded
   expose x y dc myPen change al. fid nn what array
   change = 0
   x = self~factorx
   y = self~factory
   dc = self~getButtonDC(100)
   myPen   = self~createPen(1,'solid',0)
   t    = .TimeSpan~fromMicroSeconds(500000) -- .5 seconds
   msg  = .Message~new(self,'life')
   alrm = .Alarm~new(t, msg)
   array=.local~myArrayData
   Do s=1 to array~items
     al.s=array[s]
     Parse Var al.s ' == ' al.s
     End
   nn=s-2
   --say 'nn'nn
   Call lineout fid

::method interrupt unguarded

   self~interrupted = .true

::method cancel unguarded   -- Stop the drawing program and quit.
   expose x y
   self~hide
   self~interrupted = .true
   return self~cancel:super

::method leaving unguarded  -- Best place to clean up resources
   expose dc myPen walterFont

   self~deleteObject(myPen)
   self~freeButtonDC(/*IDC_PB_DRAW*/100,dc)
   self~deleteFont(walterFont)

::method life unguarded                           /* draw individual pixels */
   expose x y dc myPen change walterFont al. nn what
   mx = trunc(20*x); my = trunc(20*y); size = 400

   curPen = self~objectToDC(dc, myPen)

   -- Select the nice big letters and digits into the device context to use to
   -- to write with:
   curFont = self~fontToDC(dc, walterFont)

   -- Create a white brush and select it into the device to paint with.
   whiteBrush = self~createBrush(10)
   curBrush   = self~objectToDC(dc, whiteBrush)

   -- Paint the drawing area surface with the white brush
   self~rectangle(dc, 1, 1, 500, 600, 'FILL')
   self~writeDirect(dc,  10, 20,'Conway''s Game of Life')
   self~writeDirect(dc,  10, 40,.local~title)
   self~writeDirect(dc,  10,460,'Walter Pachl, 8 Aug 2014')
   dx=.local~dxval
   dy=.local~dyval
   do s=1 By 1 until self~interrupted
     self~transparentText(dc)
     self~interrupted = .false
     sm=s//nn+1
     If s>1 Then Do
       ali=al.sb
       Do While ali<>''
         Parse Var ali x ',' y ali
         zxa=(x+dx)*10
         zya=(y+dy)*10
         self~draw_square(dc,zxa,zya,3,10)
         End
       End
     self~draw_square(dc, 380, 10,100,10)
     self~writeDirect(dc, 340, 20,time())
     self~writeDirect(dc, 340, 40,right(sm,2) 'of' right(nn,2))
     ali=al.sm
     Do While ali<>''
       Parse Var ali x ',' y ali
       zxa=(x+dx)*10
       zya=(y+dy)*10
       self~draw_square(dc,zxa,zya,3,5)
       End
 --    self~interrupted = .true
     sb=sm
     self~objectToDC(dc, curPen)
     self~objectToDC(dc, curBrush)
     call msSleep .local~myspeed
   --self~pause
     End

::method pause
   j = msSleep(10)

::method draw_square
  Use Arg dc, x, y, d, c
  Do zx=x-d to x+d
    Do zy=y-d to y+d
      self~drawPixel(dc, zx, zy, c)
      End
    End

::method quot
  Parse Arg x,y
  If y=0 Then Return '???'
  Else Return x/y

::routine tl
/* REXX ---------------------------------------------------------------
* 02.08.2014 Walter Pachl
* Input is a file containing the initial pattern
* The compute area is extended when needed
*   (cells are born outside the current compute area)
* The program stops when the picture shown is the same as the first
*   or equal to the previous one
*--------------------------------------------------------------------*/
Parse Arg f
If f='' Then f='bipole'
fid=f'.in'
oid=f'.txt'; 'erase' oid
oil=f'.lst'; 'erase' oil
debug=0
If debug Then Do
  dbg=f'.xxx'; 'erase' dbg
  End
ml=0
l.=''
ol.=''
Parse Value '10 10' With xb yb
xc=copies(' ',xb)
Do ri=yb+1 By 1 While lines(fid)>0
  l.ri=xc||linein(fid)
  ml=max(ml,length(strip(l.ri,'T')))
  End
ri=ri-1
ml=ml+xb
ri=ri+yb
yy=ri
a.=' '
b.=' '
m.=''
x.=''
list.=''
Parse Value 1 ml 1 yy With xmi xma ymi yma
Parse Value '-10 30 -10 30' With xmi xma ymi yma
Parse Value '999 -999  999 -999 999 -999 999 -999',
       With xmin xmax ymin ymax xlo xhi  ylo yhi
Do y=1 To yy
  z=yy-y+1
  l=l.z
  Do x=1 By 1 While l<>''
    Parse Var l c +1 l
    If c='*' Then
      a.x.z='*'
    End
  End
Call show
Do step=1 To  60
  Call store
  If step>1 & is_equal(step,1) Then Leave
  If step>1 & is_equal(step,step-1) Then Leave
  Call show_neighbors
  Do y=yma To ymi By -1
    ol=format(x,3)' '
    Do x=xmi To xma
      neighbors=neighbors(x,y)
      If a.x.y=' ' Then Do             /* dead cell                  */
        If neighbors=3 Then Do
          b.x.y='*'                    /*  gets life                 */
          mmo=xmi xma ymi yma
          xmi=min(xmi,x-1)
          xma=max(xma,x+1)
          ymi=min(ymi,y-1)
          yma=max(yma,y+1)
          mm=xmi xma ymi yma
          If mm<>mmo Then
            Call debug mmo '1->' mm
          End
        Else                           /* life cell                  */
          b.x.y=' '                    /*  remains dead              */
        End
      Else Do                          /* life cell                  */
        If neighbors=2 |,
           neighbors=3 Then Do
          b.x.y='*'  /*  remains life              */
          mmo=xmi xma ymi yma
          xmi=min(xmi,x-1)
          xma=max(xma,x+1)
          ymi=min(ymi,y-1)
          yma=max(yma,y+1)
          mm=xmi xma ymi yma
          If mm<>mmo Then
            Call debug mmo '2->' mm
          End
        Else
          b.x.y=' '  /*  dies                      */
        End
      End
    End
  /* b. is the new state and is now copied to a.                     */
  Do y=yma To ymi By -1
    Do x=xmi To xma
      a.x.y=b.x.y
      End
    End
  End
/* Output name and all states                                        */
Call lineout oid,' 'f
st=' +'                                /* top and bottom border      */
sb=' +'                                /* top and bottom border      */
Do s=1 To step
  st=st||'-'right(s,2,'-')||copies('-',xmax-xmin-2)'+'
  sb=sb||copies('-',xmax-xmin+1)'+'
  End
array=.array~new
Do y=ymin To ymax
  Do s=1 To step
    Do x=xmin To xmax
      If substr(m.s.y,x,1)='*' Then Do
        xlo=min(xlo,x)
        xhi=max(xhi,x)
        ylo=min(ylo,y)
        yhi=max(yhi,y)
        End
      End
    End
  End
Do y=ymin To ymax
  ol=''
  Do s=1 To step
    Do x=xmin To xmax
      If substr(m.s.y,x,1)='*' Then Do
        list.s=list.s (x-xlo+1)','||(y-ylo+1)
        End
      End
    array[s]=s '-' words(list.s) '==' list.s
    End
  --Call lineout oid,ol '|'
  .local~myArrayData=array
  End
height=yhi-ylo+1
width=xhi-xlo+1
.local~dxval=(48-width)%2
.local~dyval=(48-height)%2
Call o st                        /* top border                 */
xl.='|'
Do y=ymax To ymin By -1
  Do s=1 To step
    xl.y=xl.y||substr(ol.s.y,xmin,xmax-xmin+1)'|'
    End
  End
Do y=ymax To ymin By -1
  Call o ' 'xl.y
  End
Call o sb                    /* bottom border              */
Call lineout oid
Say 'frames are shown in' oid
If debug Then Do
  Say 'original area' 1 ml '/' 1 yy
  Say 'compute area ' xmi xma '/' ymi yma
  Say 'used area    ' xlo xhi '/' ylo yhi
  End
Do s=1 To step
  call lineout oil,s '==>' words(list.s) '=='  list.s
  End
Return

o: Parse Arg lili
   Call lineout oid,lili
   Return

set: Parse Arg x,y
     a.x.y='*'
     Return

neighbors: Procedure Expose a. debug
  Parse Arg x,y
  neighbors=0
  do xa=x-1 to x+1
    do ya=y-1 to y+1
      If xa<>x | ya<>y then
        If a.xa.ya='*' Then
          neighbors=neighbors+1
      End
    End
  Return neighbors

store:
/* store current state (a.) in lines m.step.*                        */
Do y=yma To ymi By -1
  ol=''
  Do x=xmi To xma
    z=a.x.y
    ol=ol||z
    End
  x.step.y=ol
  If ol<>'' then Do
    ymin=min(ymin,y)
    ymax=max(ymax,y)
    p=pos('*',ol)
    q=length(strip(ol,'T'))
    If p>0 Then
      xmin=min(xmin,p)
    xmax=max(xmax,q)
    End
  m.step.y=ol
  ol.step.y=ol
  --If pos('*',ol)>0 Then Do
  --  Say '====>' right(step,2) right(y,3) '>'ol'<'  xmin xmax
  --  Say '              'copies('1234567890',3)
  --  End
  End
Return

is_equal:
/* test ist state a.b is equal to state a.a                          */
  Parse Arg a,b
  Do y=yy To 1 By -1
    If x.b.y<>x.a.y Then
      Return 0
    End
  Return 1

show: Procedure Expose dbg a. yy ml debug
Do y=-5 To 13
  ol='>'
  Do x=-5 To 13
    ol=ol||a.x.y
    End
  Call debug ol
  End
Return

show_neighbors: Procedure Expose a. xmi xma ymi yma dbg debug
  Do y=yma To ymi By -1
    ol=format(y,3)' '
    Do x=xmi To xma
      ol=ol||neighbors(x,y)
      End
    Call debug ol
    End
  Return

debug:
  If debug Then
    Return lineout(dbg,arg(1))
  Else
    Return
