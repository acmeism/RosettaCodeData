/* REXX ---------------------------------------------------------------
* 09.02.2014 Walter Pachl with a little, well considerable, help from
*                         a friend (Mark Miesfeld)
* 1) downstripped an example contained in the ooRexx distribution
* 2) constructed the squares for seconds, minutes, and hours
* 3) constructed second-, minute- and hour hand
* 5) removed lots of unnecessary code (courtesy mark Miesfeld again)
* 6) painted the background white
* 7) display date as well as time as text
* 21.02.2014 Attempts to add a minimize icon keep failing
*--------------------------------------------------------------------*/
 d = .drawDlg~new
 if d~initCode <> 0 then do
    say 'The Draw dialog was not created correctly.  Aborting.'
    return d~initCode
 end
 d~execute("SHOWTOP")
 return 0

::requires "ooDialog.cls"
::requires 'rxmath' library

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

-- if \self~createcenter(200, 230,"Walter's Clock","MINIMIZEBOX", ,"System",14) then
   if \self~createcenter(200, 230,"Walter's Clock",,,"System",14) then
      self~initCode = 1
-- self~connectDraw(100, "clock", .true)

::method defineDialog
-- self~createPushButton(/*IDC_PB_DRAW*/100,0,0,240,200,"NOTAB OWNERDRAW") -- The drawing surface.
-- self~createPushButton(/*IDC_PB_DRAW*/100,0,0,240,180,"DISABLED NOTAB") -- better. ???
   self~createPushButton(/*IDC_PB_DRAW*/100,0,0,200,200,"DISABLED NOTAB") -- better. ???

   self~createPushButton(IDCANCEL,160,212, 35, 12,,"&Cancel")

::method initDialog unguarded
   expose x y dc myPen change
   change = 0
   x = self~factorx
   y = self~factory
   dc = self~getButtonDC(100)
 --+  myPen   = self~createPen(1,'solid',0)
   t    = .TimeSpan~fromMicroSeconds(500000) -- .5 seconds
   msg  = .Message~new(self, 'clock')
   alrm = .Alarm~new(t, msg)

::method interrupt unguarded

   self~interrupted = .true

::method cancel unguarded   -- Stop the drawing program and quit.
   expose x y
   self~hide
   self~interrupted = .true
   return self~cancel:super

::method leaving unguarded  -- Best place to clean up resources
   expose dc myPen walterFont

 --+  self~deleteObject(myPen)
   self~freeButtonDC(/*IDC_PB_DRAW*/100,dc)
   self~deleteFont(walterFont)

::method clock unguarded                           /* draw individual pixels */
   expose x y dc myPen change walterFont
-- Say 'clock started'
   mx = trunc(20*x); my = trunc(20*y); size = 400

 --+  curPen = self~objectToDC(dc, myPen)

   -- Select the nice big letters and digits into the device context to use to
   -- to write with:
   curFont = self~fontToDC(dc, walterFont)

   -- Create a white brush and select it into the device to paint with.
   whiteBrush = self~createBrush(10)
   curBrush   = self~objectToDC(dc, whiteBrush)

-- Paint the drawing area surface with the white brush
--   self~rectangle(dc, 1, 1, 500, 450, 'FILL') -- how does that relate to the 180 above ???
--   self~rectangle(dc, 1, 1, 480, 400, 'FILL') -- how does that relate to the 180 above ???

   button = self~newPushButton(100)
   clRect = button~clientRect;  -- Say clRect
   self~rectangle(dc, clRect~left+10, clRect~top+10, clRect~right-10, clRect~bottom-10, 'FILL')

   self~transparentText(dc)
   self~writeDirect(dc, 55,20*y,"Walter's Clock")
   self~writeDirect(dc,236, 56,'12')
   self~writeDirect(dc,428,220,'3')
   self~writeDirect(dc,245,375,'6')
   self~writeDirect(dc, 60,220,'9')
   self~opaqueText(dc)

   -- These 5 lines just have the effect of showing "Walter's Clock" first
   -- for a brief instant before the other drawing shows.  If you want it all
   -- to show at once, then remove this.
/*
   if change \= 2 then do
     call msSleep 1000
     change = 2
     end
*/
   self~interrupted = .false

   sec=0
   min=0
   hhh=0
   fact=rxCalcPi()/180
   Parse Value '-1 -1 -1 -1' With hho mmo sso hopo

   do dalpha=0 To 359 by 30 until self~interrupted
     alpha = dalpha*fact
     zxa=trunc(250+124*rxCalcSin(alpha,,'R'))
     zya=trunc(230-110*rxCalcCos(alpha,,'R'))
     hhh=right(hhh,2,0)
     hhh.hhh=right(zxa,3) right(zya,3)
     hhh+=1
     self~draw_square(dc,zxa,zya,3,5)
     self~draw_square(dc,zxa,zya,2,10)
     End
   Do a=0 To 59
     a=right(a,2,0)
     alpha=a*6*fact
     sin.a=rxCalcSin(alpha,,'R')
     cos.a=rxCalcCos(alpha,,'R')
     sin.0mhh.a=sin.a
     cos.0mhh.a=cos.a
     End
   Do hoi=0 To 12*60-1
     hoi=right(hoi,3,0)
     alpha=(hoi/2)*fact
     sin.0hoh.hoi=rxCalcSin(alpha,,'R')
     cos.0hoh.hoi=rxCalcCos(alpha,,'R')
     End
   do dalpha=0 To 359 by 6 until self~interrupted
      alpha = dalpha*fact
      zxa=trunc(250+165*rxCalcSin(alpha,,'R'))
      zya=trunc(230-140*rxCalcCos(alpha,,'R'))
      sec=right(min,2,0)
      sec.sec=right(zxa,3) right(zya,3)
      sec+=1
      self~draw_square(dc,zxa,zya,3,5)
      self~draw_square(dc,zxa,zya,2,10)
      zxa=trunc(250+140*rxCalcSin(alpha,,'R'))
      zya=trunc(230-125*rxCalcCos(alpha,,'R'))
      min=right(min,2,0)
      min.min=right(zxa,3) right(zya,3)
      --Call lineout 'pos.xxx',right(min,2) 'min='min.min
      min+=1
      self~draw_square(dc,zxa,zya,3,5)
      self~draw_square(dc,zxa,zya,2,10)
      End

   do dalpha=0 by 6 until self~interrupted
      alpha=dalpha*fact
      zxa=trunc(250+165*rxCalcSin(alpha,,'R'))
      zya=trunc(230-140*rxCalcCos(alpha,,'R'))
      time=time()
      parse Var time hh ':' mm ':' ss
      If hh>=12 Then hh=right(hh-12,2,0)
      self~writeDirect(dc, 355,40,time)
      date=date()
      self~writeDirect(dc, 355,60,date)
      If hh<>hho Then Do
        If hho>=0 Then Do
          Parse Var hhh.hho hx hy
          self~draw_square(dc,hx,hy,2,10)
          End
        Parse Var hhh.hh hx hy
        self~draw_square(dc,hx,hy,2,2)
        End
      If mm<>mmo Then Do
        If mmo>=0 Then Do
          Parse Var min.mmo mx my
          self~draw_square(dc,mx,my,2,10)
          End
        Parse Var min.mm mx my
        self~draw_square(dc,mx,my,2,2)
        End
      If ss<>sso Then Do
        If sso>=0 Then Do
          Parse Var sec.sso sx sy
          self~draw_square(dc,sx,sy,2,10)
          self~draw_second_hand(dc,sso,sin.,cos.,10)
          End
        Parse Var sec.ss sx sy
        self~draw_square(dc,sx,sy,2, 2)
        self~draw_second_hand(dc,ss,sin.,cos.,16)
        self~draw_square(dc,250,230,4,1)
        hop=right(hh*60+mm,3,0)
        self~draw_hour_hand(dc,hop,sin.,cos.,13)
        self~draw_minute_hand(dc,mm,sin.,cos.,14)
        End
      If mm<>mmo Then Do
        If hopo>=0 Then
          self~draw_hour_hand(dc,hopo,sin.,cos.,10)
        hop=right(hh*60+mm,3,0)
        self~draw_hour_hand(dc,hop,sin.,cos.,13)
        hopo=hop
        If mmo>=0 Then
          self~draw_minute_hand(dc,mmo,sin.,cos.,10)
        self~draw_minute_hand(dc,mm,sin.,cos.,14)
        End
      self~draw_square(dc,250,230,4,1)
      hho=hh
      mmo=mm
      sso=ss

      call msSleep 100
      self~pause
   end
--   if kpix >= size then kpix = 1

   self~interrupted = .true
 --+  self~objectToDC(dc, curPen)
   self~objectToDC(dc, curBrush)

::method pause
   j = msSleep(10)

::method draw_square
  Use Arg dc, x, y, d, c
  Do zx=x-d to x+d
    Do zy=y-d to y+d
      self~drawPixel(dc, zx, zy, c)
      End
    End

::method draw_hour_hand
  Use Arg dc, hp, sin., cos., color
  Do p=1 To 60
    zx=trunc(250+p*sin.0hoh.hp)
    zy=trunc(230-p*cos.0hoh.hp)
    self~draw_square(dc, zx, zy, 2, color)
    End

::method draw_minute_hand
  Use Arg dc, mp, sin., cos., color
  Do p=1 To 80
    zx=trunc(250+p*sin.0mhh.mp)
    zy=trunc(230-p*cos.0mhh.mp)
    self~draw_square(dc, zx, zy, 1, color)
    End

::method draw_second_hand
  Use Arg dc, sp, sin., cos., color
  Do p=1 To 113
    zx=trunc(250+p*sin.sp)
    zy=trunc(230-p*(140/165)*cos.sp)
    self~draw_square(dc, zx, zy, 0, color)
    End

::method quot
  Parse Arg x,y
  If y=0 Then Return '??'
  Else Return x/y
