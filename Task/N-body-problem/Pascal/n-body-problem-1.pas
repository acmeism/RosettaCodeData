{$N+ Crunch only the better sort of numbers, thanks.}
{$M 50000,24000,24000] {Stack,minheap,maxheap.}
Program Swirl; Uses Graph, Crt;
{   Calculates and displays the orbit of an asteroid around a sun and a planet,
 as described in the article by C.C. Foster, in Sky & Telescope, September 1994,
 which included the source code of a programme written in basic, so some changes here.

    The situation: the asteroid is at X = (AX,AY) with velocity V = (VAX,VAY)
 and suffers acceleration from the central sun and the steadily orbiting planet.
 If the acceleration at the start of a time step is A = (acX,acY)
  then X = (A.dt/2 + V)dt + X   at the end of a time step, A presumed constant.
   and V = A.dt + V             (so update X before altering V)
 But that is a first-order method. The whole point is that A is not constant.
 Accordingly, use this X as an estimate of the position at the end of a time step,
 and calculate a fresh A at the new position. Use the average of this and the
 first A to perform the actual step.
    The next step in the escalation is the classic fourth-order Runge-Kutta method
 that alas involves a lot of repetitious code, or else trickery with loops.
 Whichever, there are four evaluations per step: at the start, then using that to
 probe ahead a half step, then again a half step, then a full step probe, then
 a weighted average to perform the step. While this gives fifth-order accuracy
 for each step, and thus fourth order accuracy at the end of a sequence of steps,
 this is rather painful. This is to say that halving the step size would
 reduce the upper bound of the error in a single step by a factor of 2**5, and
 that for the result after a sequence of steps by a factor of 2**4. However,
 this requires an upper bound on the value of the higher order derivatives of
 the function over the entirety of the area of interest, and for this problem,
 it does not exist, for the acceleration is unbounded above as a particle approaches
 a mass. It varies by 1/r**2 and as r approaches zero, there can be surprises.
    Unfortunately, the next stages, say Milne's Predictor-Corrector (which has
 the advantage of maintaining  the recent history, just what procedure Apastron
 needs), followed by the extrapolation to zero stepsize methods of Bulirsch and
 Stoer require heavy administration.
    This programme uses a few tricks to enable a step size of 1 so that no actual
 multiplication need be made, and likewise takes G as being one. It is the work
 of moments to change the step size with these methods, but the difficulty lies
 in when to change the step size and by how much. Remember that with a large step,
 singularities can be stepped over without noticing them, whereas a small step
 involves not just more work but also accumulating round-off. The predictor-
 corrector methods offer a good check on the step size (if you bother to compare
 the difference between the predicted and corrected values) but require a lot
 of administrative effort when changing it. However, this is not all to the bad
 as you might as well add some checks that the step size is not being changed
 too enthusiastically while you're at it. The problem is that the step size is
 being changed according to the behaviour of the results, but the behaviour of
 the results depends on the step size as well as the current region.
    Rather than pursue this matter (and make the effort) I have retained the
 fixed size step (but perhaps an option sometime later?) to allow comparison
 with the original article in Sky & Telescope (and also to make things easy
 for procedure Apastron). For close comparison you will need to fix the central
 sun (i.e. Wobble is false) and use Euler's method. The article however uses
 units convenient to its programme: the planet is at radius 200, the asteroid
 at 100, both starting on the x-axis. The planet has a mass of 5 to the sun's
 mass of 70 (which is more like that of a companion sun than a planet), with
 a year of 920 steps and the asteroid has an initial velocity in the y-direction
 of 0.7. (See why you shouldn't use full stops as decimal points!)
    These conditions result in the asteroid having successive periods of 466,
 452, 477, 437, etc steps in the original article, and the invocation

    WANDER 920 0.0714285  0.5 0  0.0  1.1  r f

    meaning
      920 steps to the planet's orbit,
      a planetary mass of 5/70 of the sun
      asteroid's radial distance being half that of the planet
      at zero degrees (i.e. on the x-axis)
      zero radial velocity
      circular velocity of 1.1 (an estimate from trials) times that of a circular
         orbit at the asteroid's initial radius
      Runge-Kutta method
      Sun fixed at the centre of mass

    Is about as close as I can get, giving an asteroid period of 390 or so.
    But the orbit is very unstable. With Euler's method, the picture is even worse
 with the asteroid spiralling outwards. I think that this is due to too large a
 step size and a low-order method, as test runs with the planetary mass set zero
 behave better, provided that there are many steps to an asteroid orbit and that it
 doesn't pass close to a mass. StepSize control would help, but it would mean
 more programming effort. Alternatively, I could have blundered, but I've stared
 at this so long that if there is a blunder, I can't see it.
    I prefer to believe that the step size is the problem. In a different programme
 on a different machine, a circular orbit of 90 mins about the earth (just above
 the atmosphere) with full units for G, etc, and a step size of one second (thus
 no multiply) so that there were 5,400 steps to an orbit, Euler's method after
 one orbit had the radial distance 2% high and increasing steadily, whereas the
 2'nd order Euler's method with a two second step size (so the same number of
 evaluations, as two per step) and also no multiplication (i.e. (a + a')/2 *dt) gave
 an error of one part on 6,000,000 (the precision of the 32-bit floating point
 numbers on an IBM1130) and oscillating.
    On the other hand, a simple arrangement such as the asteroid in a Trojan
 orbit with respect to the planet works well enough. Here the asteroid is in the
 same orbit as the planet, but leading (or lagging) by sixty degrees, thus:

    WANDER 920 0.001 1 +60  0 1

    Test runs give an unstable orbit unless the planet is much smaller than 5/70
 of the sun's mass, and also require that the sun not be fixed to the centre of
 mass. Having lots more steps per orbit doesn't change this. Thus, even though
 the sun's wobble is small, it is necessary and anyway, physically correct.
 In the case of a more massive planet, the obvious extension is to three equal
 masses in mutual orbit and invoking symmetry, a nice circular orbit would have
 them spaced at a hundred and twenty degrees.
    Incidentally, no attempt is made to spot occasions when the asteroid's position
 is exactly that of some attracting mass, so zero divisions can cause dismay.
 Except that they won't happen as a result of a computed step unless you are very
 unlucky, especially if the floating-point hardware is available, with eighteen
 digits that must all coincide. On the other hand, you can easily specify an
 initial position that will provoke a division by zero so if that is what you
 have asked for, then that is what you will receive.}


{Perpetrated by R.N.McLean (whom God preserve), Victoria University, Feb. VMMI.}

 Type Grist = {$IFOPT N+} extended {$ELSE} real {$ENDIF};
 Type Chaff  = {$IFOPT N+} single   {$ELSE} real {$ENDIF};
 const esc = #27;
 var colour,lastcolour,xmax,ymax,txtheight: integer;
 var stretch: grist;
 Var Asitwas: Word;
 Type AnyString = string[80];

 Function Min(i,j: integer): integer; BEGIN if i <= j then min:=i else min:=j; END;
 Function Max(i,j: integer): integer; BEGIN if i >= j then max:=i else max:=j; END;
 Procedure Beep(f,t: integer); BEGIN Sound(f); delay(t); NoSound; END;
 Procedure Croak(Gasp: string);        {A lethal word.}
  BEGIN
   TextMode(Asitwas);
   WriteLn;
   Writeln(Gasp);
   HALT;
  END;

 Function MemGrab(Var p: pointer;s: word): boolean;
  BEGIN
   p:=nil;
   if s > 0 then GetMem(p,s);
   MemGrab:=p<>nil;
  END;
 Procedure MemDrop(Var p: pointer;s: word);
  BEGIN
   if (s > 0) and (p <> nil) then FreeMem(p,s);
   p:=nil;                              {Oh that all usage would first check!}
  END;

 FUNCTION Trim(S : anystring) : anystring;
 var L1,L2 : integer;
 BEGIN
   L1 := 1;
   WHILE (L1 <= LENGTH(S)) AND (S[L1] = ' ') DO INC(L1);
   L2 := LENGTH(S);
   WHILE (S[L2] = ' ') AND (L2 > L1) DO DEC(L2);
   IF L2 >= L1 THEN Trim := COPY(S,L1,L2 - L1 + 1) ELSE Trim := '';
 END; {Of Trim.}

 FUNCTION Ifmt(Digits : longint) : anystring;
  var  S : anystring;
  BEGIN
   STR(Digits,S);
   Ifmt := Trim(S);
  END; { Ifmt }

 FUNCTION Ffmt(Digits: grist; Width,Decimals: integer): anystring;
  var
   S : anystring;
   L : integer; { a finger }
  BEGIN
   if digits = 0 then begin Ffmt:='0'; exit; end; {Mumble.}
   IF Abs(Digits) < 0.0000001 THEN STR(Digits,S)
    ELSE STR(Digits:Width:Decimals,S);
   s:=trim(s);
   if copy(s,1,2) = '0.' then s:=copy(s,2,Length(s) - 1);
   if copy(s,1,3) = '-0.' then s:=concat('-',copy(s,3,Length(s) - 2));
   l:=Length(s);
   if pos('.',s) > 0 then while (l > 0) and (s[l] = '0') do l:=l - 1;
   if s[l] = '.' then l:=l - 1;         {No non-zero fractional part!}
   S := COPY(S,1,L);                    {Drop trailing boredom.}
   l:=Pos('.',S);                       {Avoid sequences such as 3.1415.}
   if l > 0 then s[l]:=chr(249);        {By using decimal points, please.}
   Ffmt := S;
  END; { Ffmt }

 Function Atan2(x,y: grist): grist;
  var a: grist;
  BEGIN
   if x = 0 then
    if y > 0 then atan2:=pi/2
     else if y < 0 then atan2:=-pi/2
      else atan2:=0
    else if x > 0 then if y >= 0 then atan2:=arctan(y/x) else atan2:=2*pi + arctan(y/x)
     else atan2:=pi - arctan(-y/x);
  END;

 Procedure PrepareTheCanvas;
  Var mode: integer;
  Var SavedResultCode: integer;
  Var ax,ay: word;
  Function BGIFound(Here: Anystring): boolean;
   Var driver: integer;
   BEGIN
    Driver:=Detect;
    InitGraph(driver,mode,Here);
    SavedResultCode:=GraphResult;      {Mumble!}
    BGIFound:=SavedResultCode = 0;     {Missing file gives -3.}
   END; {Of BGIFound.}
  Var aplace: anystring;
  Var Palette: paletteType;
  BEGIN
   Mode:=0;
   if not BGIFound('') then
    if not BGIFound('C:\TP7\BGI') then
     if not BGIFound('D:\TP4') then
      begin
       WriteLn;
       WriteLn('Trouble with Borland''s Graphic Interface!');
       WriteLn('Message: ',GraphErrorMsg(SavedResultCode));
       WriteLn('I''ve tried "", "C:\TP4", and "D:\TP4"...');
       Repeat
        Write('Another place to look? (e.g. a:\bgiset)');
        ReadLn(Aplace);         {As opposed to Read. weird.}
        If Aplace = '' then
         begin
          writeln;
          write('No .bgi, no piccy.');
          halt;
         end;
       until BGIFound(Aplace);
      end;
   SetViewPort(0,0,GetMaxX,GetMaxY,True); {Clipping on, thanks. No apparent slowdown.}
   SetGraphMode(Mode);
   GetPalette(Palette);
   LastColour := Palette.Size - 1; {Colours are 0:15, 16 thereof.}
   if LastColour <= 0 then LastColour:=1;
   xmax:=GetMaxX; ymax:=GetMaxY;
   txtheight:=TextHeight('I');
   GetAspectRatio(ax,ay); stretch:=ay/ax; {I hope this handles the screen's physical dimensions}
  END;                                    {as well as the number of dots in the x and y directions.}

 Procedure Splot(x,y:integer; bumf: anystring);
  var l: integer;
  BEGIN
   l:=TextWidth(Bumf);
   if x + l > xmax then x:=xmax - l;
   SetFillStyle(EmptyFill,Black); Bar(x,y,x + l,y + txtheight - 1);
   OutTextXY(x,y,bumf);
  END;

 Procedure FlashHint(msg: string);
  var i,h,ph,pl,y0,rt: integer;
  var l1,l2,nl: integer;
  var board: pointer; BoardSize: word;
  BEGIN
   nl:=0; pl:=0; l2:=1;
   repeat
    l1:=l2;
    while (l2 <= Length(msg)) and (msg[l2] <> '%') do l2:=l2 + 1;
    nl:=nl + 1; pl:=max(pl,TextWidth(Copy(Msg,l1,l2 - l1)));
    l2:=l2 + 1;
   until l2 > Length(msg);
   h:=TextHeight('Idiotic') + 1;
   ph:=1 + nl*h;
   y0:=GetMaxY div 6 + h;
   BoardSize:=ImageSize(0,0,pl,ph);
   If BoardSize <= 0 then begin Beep(6666,200); exit; end;
   if KeyPressed then exit;        {Last chance to cut and run.}
   if not memgrab(board,BoardSize) then
    begin
     OutTextXY(0,y0,'Memory shortage...');
     Beep(8888,200);
     exit; {Thus save on too many "if"s below.}
    end;
   GetImage(0,y0,pl,y0 + ph,board^);    {Doesn't check that Board is not nil!&^$#@!}
   SetFillStyle(EmptyFill,Black); Bar(0,y0,pl,y0 + ph);
   SetColor(White);
   i:=0; l2:=1;
   repeat
    l1:=l2;
    while (l2 <= Length(msg)) and (msg[l2] <> '%') do l2:=l2 + 1;
    OutTextXY(0,y0 + 1 + i*h,Copy(Msg,l1,l2 - l1));
    i:=i + 1; l2:=l2 + 1;
   until l2 > Length(msg);
   rt:=28 + Length(msg);     {Read time, more for longer messages.}
   i:=0; while not KeyPressed and (i < rt) do
    begin
     delay(100);
     i:=i + 1;
    end;
   PutImage(0,y0,board^,NormalPut);
   MemDrop(board,BoardSize);
  END;

 PROCEDURE LurkWith(Msg: string);
  Var t,w: integer;
  BEGIN
   w:=111;
   repeat
    for t:=0 to w do
     begin
      if KeyPressed then exit;
      delay(100);
     end;
    FlashHint(msg);
    w:=222;
   until KeyPressed;
  END;

 Function KeyFondle: char;             {Equivalent to ReadKey, except...}
  Var ticker: integer;                 { after a delay, it gives a hint.}
  BEGIN                                {Screen and keyboard are connected by a computer...}
   Ticker:=666;                        {A delay counter.}
   While not KeyPressed do             {If nothing has happened, }
    begin                              { twiddle my thumbs.}
     ticker:=ticker - 1;               {My patience is being exhausted.}
     if ticker > 0 then Delay(60)      {Another irretrievable loss.}
      else FlashHint('Press a key!');  {Hullo sailor!}
    end;                               {Eventually, a key is pressed.}
   KeyFondle:=ReadKey                  {Yum.}
  END;


 Var Wobble,Dotty: boolean;
 Var Style: integer;
 Var Year,PM,SM,AR,AA,ARV,ACV: grist;
 Var n: longint;
 Procedure WanderAlong;
  const suncolour = Yellow;
  const planetcolour = LightGreen;
  const asteroidcolour = White;
  const anglecolour = cyan;
  const periodcolour = LightRed;
  Const radiuscolour = LightBlue;
  Const KeplerColour = Magenta;
  Const EnergyColour = White;
  Const dt = 1;
  var
   W,P,T,
   SX,SY,RS,
   PX,PY,RP,
   AX,AY,VAX,VAY,acX,acY,
   DSX,DSY,DS2,DS3,
   DPX,DPY,DP2,DP3: grist;
  var cxp,cyp,sxp,syp,pxp,pyp,axp,ayp: integer;
  var bxp,txp,byp,typ: integer;
  var nturn: longint;
  var T1,T2: grist;
  var pAX,pAY,ppAX,ppAY,D2,pD2,ppD2: grist;
  Var nstep: longint;
  var stepwise,bored: boolean;

  Function AsteroidEnergy: grist; {The asteroid mass is considered divided out.}
   BEGIN                          {Thus, 1/2 mv**2 becomes 1/2 v**2.}
    AsteroidEnergy:=(VAX*VAX + VAY*VAY)/2
     - SM/sqrt((AX - SX)*(AX - SX) + (AY - SY)*(AY - SY))
     - PM/sqrt((AX - PX)*(AX - PX) + (AY - PY)*(AY - PY));
   END;                           {Likewise, potential Energy = -G*M1*M2/r12 }

  Procedure SplotStep;
   BEGIN
    SetColor(LightBlue);
    Splot(0,0,'Steps: ' + ifmt(nstep));
    Splot(4*cxp div 3,0,'R='+ffmt(sqrt(AX*AX + AY*AY),8,2));
    SetColor(EnergyColour);
    Splot(4*cxp div 3,Txtheight,'E/m: '+ ffmt(AsteroidEnergy,8,2) + ' ');
   END;

  const types = 5;
  Const tummy = 666;
  var v: array[1..types,1..tummy] of Chaff;
  var vmax,vmin,vs: array[1..types] of Chaff;
  var show,varies: array[1..types] of boolean;
  const vcolour: array[1..types] of byte = (anglecolour,periodcolour,radiuscolour,KeplerColour,EnergyColour);
  var nv: integer;

  Procedure Splash;
   var i,j: integer;
   BEGIN
    SetFillStyle(EmptyFill,Black); Bar(bxp,byp,txp,typ);
    SetColor(Green);
    Line(bxp,byp,txp,byp); line(txp,byp,txp,typ);
    Line(txp,typ,bxp,typ); Line(bxp,typ,bxp,byp);
    for i:=1 to types do
     if show[i] and varies[i] then
      if dotty then for j:=1 to nv-1 do putpixel(bxp + round((v[i,j] - vmin[i])*vs[i]),byp+j,vcolour[i])
       else
        begin
         setcolor(vcolour[i]);
         MoveTo(bxp + round((v[i,1] - vmin[i])*vs[i]),byp+1);
         for j:=2 to nv-1 do LineTo(bxp + round((v[i,j] - vmin[i])*vs[i]),byp+j);
        end;
   END;

  Procedure DealWith(ch: char);
   var redraw: boolean;
   BEGIN
    Case upcase(ch) of
     ESC: bored:=true;
     'J': Dotty:=not Dotty;
     'A': show[1]:=not show[1];
     'P': show[2]:=not show[2];
     'R': show[3]:=not show[3];
     'K': show[4]:=not show[4];
     'E': show[5]:=not show[5];
     'S':stepwise:=not stepwise;
     '?':FlashHint('Pressing a key may help.%APRK or E selects dots to plot%S for Stepwise%ESC to quit.');
    end;
    if pos(upcase(ch),'JAPRKE') > 0 then splash;
   END;

  Procedure Swallow(v1,v2,v3,v4,v5: grist);
   var i,j,l: integer;
   var hic,flux: boolean;
   BEGIN
    flux:=nv = 3;
    if (nv >= typ - byp) or (nv >= tummy) then
     begin
      flux:=true;
      l:=nv div 3;
      for i:=1 to types do
       for j:=l+1 to nv do v[i,j - l]:=v[i,j];
      nv:=nv - l;
      for i:=1 to types do begin vmin[i]:=v[i,1]; vmax[i]:=v[i,1]; end;
      for i:=1 to types do
       for j:=2 to nv do
        begin
         if v[i,j] > vmax[i] then vmax[i]:=v[i,j];
         if v[i,j] < vmin[i] then vmin[i]:=v[i,j];
        end;
      for i:=1 to types do
       begin
        varies[i]:=vmax[i] <> vmin[i];
        if varies[i] then vs[i]:=(txp - bxp)/(vmax[i] - vmin[i]);
       end;
     end;
    nv:=nv + 1;
    v[1,nv]:=v1; v[2,nv]:=v2; v[3,nv]:=v3; v[4,nv]:=v4; v[5,nv]:=v5;
    if nv = 1 then for i:=1 to types do begin varies[i]:=false; vmax[i]:=v[i,1]; vmin[i]:=v[i,1]; end
     else for i:=1 to types do
      begin
       hic:=false;
       if v[i,nv] > vmax[i] then begin vmax[i]:=v[i,nv]; hic:=true; end;
       if v[i,nv] < vmin[i] then begin vmin[i]:=v[i,nv]; hic:=true; end;
       if hic then vs[i]:=(txp - bxp)/(vmax[i] - vmin[i]);
       if not varies[i] then varies[i]:=vmax[i] <> vmin[i];
       flux:=flux or hic;
      end;
    if nv > 3 then
     begin
      if flux then splash;
      for i:=1 to types do
       if show[i] and varies[i] then
        if dotty then putpixel(bxp + round((v[i,nv] - vmin[i])*vs[i]),byp+nv,vcolour[i])
         else
          begin
           setcolor(vcolour[i]);
           Line(bxp + round((v[i,nv-1] - vmin[i])*vs[i]),byp+nv-1,bxp + round((v[i,nv] - vmin[i])*vs[i]),byp+nv);
          end;
     end;
   END; {of Swallow.}
  Procedure Apastron;
  {Given: at the last three time steps, DS2, pD2, and ppD2, being (squares of)
   the distances from the centre of mass, and further, DS2 < pD2, pD2 > ppD2.
   Wanted: the time of greatest distance from the sun.
   So, fit a parabola to the three equally spaced values ppD2, pD2, DS2,
   differentiate and set to zero for the extremum, solving for x.
   y = ax**2 + bx + c, and why not have x = -1, 0, +1
   Thus c = y0,                  y-1 is ppD2  so c = pD2
        b = (y1 - y-1)/2         y0  is pD2      b = (DS2 - ppD2)/2
        a = (y1 + y-1 - 2y0)/2   y1  is DS2.     a = (DS2 + ppD2 - 2pDS2)/2
   The extremum is when 2ax + b = 0
    so x = -b/2a when y is an extremum, call this h.
   and x = 0 corresponds to the middle time, which was one back, so T-dt
   Having found the time of greatest distance, a small adjustment from T
   gives the location of the asteroid then (only a small change from time T)
   and thus the direction of the apastron. Since the acceleration is at right
   angles to the velocity it won't have much effect on the angle, and being
   minimal, not much effect on the distance. But, I'm not doing the arithmetic.}
   Var X,Y,a,r,h,k,e: grist;
   BEGIN
    {splot(0,20,'ppD2:'+ffmt(ppD2,15,2)+'  ');}
    {splot(0,30,' pD2:'+ffmt(pD2,15,3)+'> ');}
    {splot(0,40,'  D2:'+ffmt(D2,15,3)+'  ');}
    h:=(ppD2 - DS2)/(DS2 + ppD2 - 2*pD2) /2;
    {splot(0,50,'   h:'+ffmt(h,15,3+'  '));}
    t2:=T + (h - 1){*dt};
    x:=((AX + ppAX - 2*pAX)/2*h + (AX - ppAX)/2)*h + pAX;
    y:=((AY + ppAY - 2*pAY)/2*h + (AY - ppAY)/2)*h + pAY;
    r:=sqrt(x*x + y*y);
    SetColor(AngleColour); Line(cxp,cyp, cxp + round(x),cyp - round(y/stretch));
    a:=atan2(x,y)*180/pi;
    nturn:=nturn + 1;
    h:=(t2 - t1)/P*Year;               {Use the planet's 'year'.}
    k:=8*r*r*r/h/h;                    {Kepler's law: G(m + m')/4pi = d**3/t**2}
    e:=(VAX*VAX + VAY*VAY)/2
     - SM/sqrt((x - SX)*(x - SX) + (y - SY)*(y - SY))
     - PM/sqrt((x - PX)*(x - PX) + (y - PY)*(y - PY));
    Splot(0,0 + 1*TxtHeight,'Orbits: ' + ifmt(nturn));
    SetColor(AngleColour);  Splot(0,ymax - 1*txtheight,'Apastron: ' + ffmt(a,8,3) + 'ø   ');
    SetColor(PeriodColour); Splot(0,ymax - 2*txtheight,'Period: ' + ffmt(h,12,3)+' ');
    SetColor(RadiusColour); Splot(cxp*4 div 3,ymax - 1*txtheight,'Rmax: ' + ffmt(r,12,4)+' ');
    SetColor(KeplerColour); Splot(cxp*4 div 3,ymax - 2*txtheight,'Kepler: ' + ffmt(k,12,3)+' ');
    Swallow(a,h,r,k,e);
    t1:=t2;
   END; {of Apastron.}

  Const Methodname: array[1..3] of string = ('Euler','Euler2','RK4');
  var nSX,nSY,nPX,nPY,nAX,nAY: grist;
  Procedure EulerStep;                        {First-order.}
   BEGIN
    DSX:=SX - AX;                             DSY:=SY - AY;
    DS2:=DSX*DSX + DSY*DSY;                   DS3:=sqrt(DS2)*DS2;
    DPX:=PX - AX;                             DPY:=PY - AY;
    DP2:=DPX*DPX + DPY*DPY;                   DP3:=sqrt(DP2)*DP2;
    acX:=SM*DSX/DS3 + PM*DPX/DP3;             acY:=SM*DSY/DS3 + PM*DPY/DP3;
   END;
  Procedure SecondOrder;                      {Modified Euler, 2nd order predictor-corrector, etc..}
   BEGIN
    EulerStep;
    nAX:=AX + (0.5*acX{*dt} + VAX){*dt};      nAY:=AY + (0.5*acY{*dt} + VAY){*dt};
    DSX:=nSX - nAX;                           DSY:=nSY - nAY;
    DS2:=DSX*DSX + DSY*DSY;                   DS3:=sqrt(DS2)*DS2;
    DPX:=nPX - nAX;                           DPY:=nPY - nAY;
    DP2:=DPX*DPX + DPY*DPY;                   DP3:=sqrt(DP2)*DP2;
    acX:=(acX + SM*DSX/DS3 + PM*DPX/DP3)/2;   acY:=(acY + SM*DSY/DS3 + PM*DPY/DP3)/2;
   END;
  Procedure RungeKutta4;                      {The classic.}
   var h2,hsx,hsy,hpx,hpy,tax,tay,k1x,k1y,k2x,k2y,k3x,k3y: grist;
   BEGIN
    EulerStep;                                {The story at 0.}
    h2:=dt/2;                                 {Half a time step.}
    hSX:=(SX + nSX)/2; hSY:=(SY + nSY)/2;     {I'm not calling for a fresh sin and cos.}
    hPX:=(PX + nPX)/2; hPY:=(PY + nPY)/2;     {Halfway will do.}
    tAX:=AX + (0.5*acX*h2 + VAX)*h2;          tAY:=AY + (0.5*acY*h2 + VAY)*h2;
    DSX:=hSX - tAX;                           DSY:=hSY - tAY;
    DS2:=DSX*DSX + DSY*DSY;                   DS3:=sqrt(DS2)*DS2;
    DPX:=hPX - tAX;                           DPY:=hPY - tAY;
    DP2:=DPX*DPX + DPY*DPY;                   DP3:=sqrt(DP2)*DP2;
    k1x:=SM*DSX/DS3 + PM*DPX/DP3;             k1y:=SM*DSY/DS3 + PM*DPY/DP3;
    tAX:=AX + (0.5*k1X*h2 + VAX)*h2;          tAY:=AY + (0.5*k1Y*h2 + VAY)*h2;
    DSX:=hSX - tAX;                           DSY:=hSY - tAY;
    DS2:=DSX*DSX + DSY*DSY;                   DS3:=sqrt(DS2)*DS2;
    DPX:=hPX - tAX;                           DPY:=hPY - tAY;
    DP2:=DPX*DPX + DPY*DPY;                   DP3:=sqrt(DP2)*DP2;
    k2x:=SM*DSX/DS3 + PM*DPX/DP3;             k2y:=SM*DSY/DS3 + PM*DPY/DP3;
    tAX:=AX + (0.5*k2X{*dt} + VAX){*dt};      tAY:=AY + (0.5*k2Y{*dt} + VAY){*dt};
    DSX:=nSX - tAX;                           DSY:=nSY - tAY;
    DS2:=DSX*DSX + DSY*DSY;                   DS3:=sqrt(DS2)*DS2;
    DPX:=nPX - tAX;                           DPY:=nPY - tAY;
    DP2:=DPX*DPX + DPY*DPY;                   DP3:=sqrt(DP2)*DP2;
    k3x:=SM*DSX/DS3 + PM*DPX/DP3;             k3y:=SM*DSY/DS3 + PM*DPY/DP3;
    acX:=(acX + 2*(k1x + k2x) + k3x)/6;       acY:=(acY + 2*(k1y + k2y) + k3y)/6;
   END;
  Const BlobSize = 8;
  var r,vcirc: grist;
  var d,m,distant2: grist;
  var coswt,sinwt: grist;
  var rsp,rpp: integer;                {Radius of Sun in Pixels, and of Planet.}
  var pspix,pppix,pswas,ppwas: pointer;{Points to Sun pix, Planet pix.}
  var szspix,szppix: word;             {Sizes of the pix map.}
  var i1,i2: integer;
  Var ch: char;
  Var text: string;
  BEGIN
   bored:=false;
   Dotty:=true;
   Stepwise:=false;
   for i1:=1 to types do show[i1]:=true;
   bxp:=xmax; pyp:=round(ymax*stretch);
   if pyp < bxp then bxp:=pyp;         {Oh for square dots!##$%$#!}
   cxp:=bxp div 2; cyp:=round(bxp/stretch/2); {The centre of mass on the screen.}
   bxp:=bxp + 1; txp:=xmax;            {Base and top of a side box.}
   byp:=0;       typ:=ymax;            {Wherein will appear a plot.}
   nv:=0;                              {No values saved for the box.}
   R:=cxp - blobsize;                  {Available space on the screen, with safety.}
   RP:=R;                              {All for the planet's radius.}
   RS:=0;                              {If the sun is motionless.}
   M:=SM + PM;                         {Total mass of the system.}
   if pm = 0 then wobble:=false;       {The asteroid is as if massless.}
   if wobble then                      {But if the sun wobbles, }
    begin                              { then a re-adjustment.}
     RS:=R*PM/M;                       {Both orbit about the centre of mass.}
     RP:=R*SM/M;                       {RS + RP = R.}
     t:=RS; if RP > t then t:=RP;      {Re-scale to fill the screen.}
     RS:=RS*R/t; RP:=RP*R/t;
    end;
   D:=RS + RP;                         {Distance between planet and sun.}
   Distant2:=6*D*D;                    {A long way out.}
   M:=4*pi*pi*D*D*D/({G}year*year) /M; {Use the proper orbital period, with G = 1.}
   SM:=SM*M; PM:=PM*M; M:=SM + PM;     {Rescale so as to allow dt = 1.}
   P:=year;
   W:=2*Pi/P;                          {2Pi radians in one orbit, needing time P}
  {dt:=P/year;                         {'Year' Timesteps complete one P.}
   rsp:=Round(BlobSize*Sqrt(SM/M)); rpp:=Round(BlobSize*Sqrt(PM/M));
   if rsp < 1 then rsp:=1;          if rpp < 1 then rpp:=1;
                   {Prepare a solar disc.}
   sxp:=cxp - round(RS); syp:=cyp - 0;
   szspix:=ImageSize(sxp-rsp,syp-rsp,sxp+rsp,syp+rsp);
   if not(MemGrab(pspix,szspix) and MemGrab(pswas,szspix)) then croak('Can''t grab memory for the solar disc.');
   GetImage(sxp-rsp,syp-rsp,sxp+rsp,syp+rsp,pswas^);
   SetColor(SunColour); Circle(sxp,syp,rsp);
   SetFillStyle(SolidFill,SunColour); FloodFill(sxp,syp,SunColour);
   GetImage(sxp-rsp,syp-rsp,sxp+rsp,syp+rsp,pspix^);
   PutImage(sxp-rsp,syp-rsp,pswas^,0); {Remove the sun during preparation.}
                   {Prepare a planetary disc.}
   pxp:=cxp + round(RP);  pyp:=cyp + 0;
   szppix:=ImageSize(pxp-rpp,pyp-rpp,pxp+rpp,pyp+rpp);
   If not(MemGrab(pppix,szppix) and MemGrab(ppwas,szppix)) then Croak('Can''t grab memory for the planetary disc.');
   GetImage(pxp-rpp,pyp-rpp,pxp+rpp,pyp+rpp,ppwas^);
   SetColor(PlanetColour); Circle(pxp,pyp,rpp);
   SetFillStyle(SolidFill,PlanetColour); {FloodFill(pxp,pyp,PlanetColour);}
   GetImage(pxp-rpp,pyp-rpp,pxp+rpp,pyp+rpp,pppix^);
   PutImage(pxp-rpp,pyp-rpp,ppwas^,0);
                   {Place some geometry.}
   SetColor(1); Line(cxp - round(rp),cyp,cxp + round(rp),cyp);
                Line(cxp,cyp + round(rp/stretch),cxp,cyp - round(rp/stretch));
                Circle(cxp,cyp,Round(RP));
   SetColor(5); Line(cxp-1,cyp,cxp+1,cyp); Line(cxp,cyp-1,cxp,cyp+1);
   GetImage(sxp-rsp,syp-rsp,sxp+rsp,syp+rsp,pswas^); {+Geometry, no sun.}
   GetImage(pxp-rpp,pyp-rpp,pxp+rpp,pyp+rpp,ppwas^); {+Geometry, no planet.}
   PutImage(sxp-rsp,syp-rsp,pspix^,0);
   SetColor(LightBlue); Splot(0,0+2*txtheight,'Method: ' + methodname[style]);
   if wobble then text:='Wobble' else text:='Fixed';
   setcolor(SunColour); Splot(0,0+3*txtheight,text);

   SX:=0;             SY:=0;           {Place the sun at the centre of mass.}
   PX:=RP;            PY:=0;           {Place the planet on the x-axis.}
   if wobble then SX:=-RS;             {Opposite sides.}
   nSX:=SX;          nSY:=SY;          {In case it doesn't wobble.}
   axp:=0;           ayp:=0;           {Previous asteroid place.}
   D:=RP*AR;                           {Distance out from the C of M.}
   AX:=D*Cos(AA); AY:=D*Sin(AA);
   VCirc:=D*2*Pi/Sqrt(4*pi*pi*D*D*D/M);  {Velocity of circular orbit.}
   VAX:=VCirc*(-ACV*Sin(AA) + ARV*Cos(AA));
   VAY:=VCirc*(+ACV*Cos(AA) + ARV*Sin(AA));
   pAX:=AX; ppAX:=AX; pAY:=AY;ppAY:=AY;{Shouldn't be needed, but fear uninitialisation.}
   D2:=AX*AX + AY*AY;                  {Distance from the centre of mass.}
   pD2:=D2;ppD2:=D2;                   {We start at the Apastron.}
   T1:=0;
   nturn:=0;
   nstep:=0;
   {The story at time T, the start of a time step dt:
    The sun's mass SM at (SX,SY) and (nSX,nSY) at the end of the time step.
    The planet     PM    (PX,PY)     (nPX,nPY)
    The asteroid         (AX,AY) velocity (VAX,VAY)
    To compute its acceleration (acX,acY)
    and therefrom a new value for (AX,AY) and (VAX,VAY).}

   repeat
    nstep:=nstep + 1;                  {Well, it is about to be made.}
    t:=nstep{*dt};                     {This time is after the step has been made.}
    CosWT:=Cos(W*T); SinWT:=Sin(W*T);  {The compiler probably does a poor job.}
    nPX:=RP*Coswt;nPY:=RP*sinwt;       {And at the end of the step.}
    if wobble then                     {In proper centre-of-mass arrangements?}
     begin                             {Yes. The sun is wobbling.}
      nSX:=-RS*CosWT; nSY:=-RS*SinWT;  {And at the end of the time step.}
     end;                              {Enough fooling around. Now for the real task.}
    Case style of
    1:EulerStep;
    2:SecondOrder;
    3:RungeKutta4;
    end;
    AX:=AX + (0.5*acX{*dt} + VAX){*dt};       AY:=AY + (0.5*acY{*dt} + VAY){*dt};
    VAX:=VAX + acX{*dt};                      VAY:=VAY + acY{*dt};
    PX:=nPX;                                  PY:=nPY;
    if wobble then begin SX:=nSX; SY:=nSY; end;  {Thus attain the end of the time step.}
    PutPixel(axp,ayp,0);                      {Scrub the old asteroidal spot.}
    axp:=cxp + round(AX);                     ayp:=cyp - Round(AY/stretch);
    PutPixel(axp,ayp,AsteroidColour);         {Place the new asteroidal spot.}
    PutImage(pxp-rpp,pyp-rpp,ppwas^,0);       {Scrub the old planetary spot.}
    pxp:=cxp + round(PX);                     pyp:=cyp - round(PY/stretch);
    GetImage(pxp-rpp,pyp-rpp,pxp+rpp,pyp+rpp,ppwas^);
    PutImage(pxp-rpp,pyp-rpp,pppix^,0);       {Place the new planetary spot.}
    if wobble then                            {The sun might be mobile, too.}
     begin                                    {So see if it has moved noticeably.}
      i1:=cxp + round(SX);                    i2:=cyp - round(SY/stretch);
      if (i1 <> sxp) or (i2 <> syp) then      {At least a whole dot in some direction?}
       begin                                  {Yep.}
        PutImage(sxp-rsp,syp-rsp,pswas^,0);   {Restore what was there.}
        sxp:=i1; syp:=i2;                     {And jump to the new position.}
        GetImage(sxp-rsp,syp-rsp,sxp+rsp,syp+rsp,pswas^);
        PutImage(sxp-rsp,syp-rsp,pspix^,0);   {Splot.}
       end;                                   {So much for a noticeable move.}
     end;                                     {So much for sun movement.}
    D2:=AX*AX + AY*AY;                 {The new position.}
    if (D2 < pD2) and (pD2 > ppD2) then Apastron;
    ppAX:=pAX; ppAY:=pAY; pAX:=AX; pAY:=AY; ppD2:=pD2; pD2:=D2;
    if stepwise or (nstep mod 100 = 0) then splotstep;
    if D2 > Distant2 then              {Too distant for close interactions?}
     if AsteroidEnergy > 0 then        {Yeah, perhaps a getaway is in progress.}
      begin
       SplotStep;
       Splot(cxp,cyp div 3,'Escaping!');
       Bored:=true;
      end;
    if stepwise or keypressed then dealwith(KeyFondle);
   until bored;

   repeat
    Text:='';
    if nv > 3 then text:='Adjust dots, or%';
    text:=text + 'ESC to quit.';
    LurkWith(Text);
    ch:=KeyFondle;
    if ch <> esc then dealwith(ch);
   until ch = esc;

   MemDrop(pspix,szspix); MemDrop(pswas,szspix);
   MemDrop(pppix,szppix); MemDrop(ppwas,szppix);
  END; {Of WanderAlong.}

 Procedure Grunt(n: integer);
  Var i: integer;
  Var Unflushed: boolean;
  Procedure Z(Text: string);      {Roll some text.}
   BEGIN                          {With screen pauses.}
    if unflushed then ClrEol;     {Perhaps bumf lurks on this line.}
    WriteLn(Text); i:=i + 1;      {Writes only to the end of text, not eol.}
    if i >= Hi(WindMax) then      {Have we reached the bottom?}
     begin                        {Yes, the display would soon scroll up.}
      if unflushed then clreol;   {A last remnant.}
      unflushed:=false;           {Once scrolling starts, new lines are blank.}
      Write('(Press a key)');     {A hint, offering out-by-one possibilities.}
      if ReadKey = #0 then if ReadKey = esc then;      {Ignore a key.}
      GoToXY(1,wherey); ClrEol;   {Scrub the hint.}
      i:=0;                       {Restart the count.}
     end;                         {So much for a screen full.}
   END;                           {So much for that line.}
  BEGIN
   i:=n; Unflushed:=true;
   Z('   A massive planet is in a fixed circular orbit about its sun.');
   Z('Between it and the sun is an asteroid that wanders as it can.');
   Z('Although this problem is (just) within the scope of analytic methods,');
   Z('the asteroid''s movement is computed by numerical integration, with one');
   Z('step per ''day'' of the planet''s orbital period. As the simulation proceeds,');
   Z('various attributes of its orbit are plotted in a box to the side of the screen');
   Z('for each completed orbit. This is taken to be when it reaches a maximum');
   Z('distance from the centre of mass, or in other words, starts to fall back.');
   Z('No attempt is made to identify other orbital centres, such as the planet');
   Z('or the Trojan points of its orbit or whatever other stabilities exist, nor');
   Z('more baroque orbits such as about both the sun and the planet.');
   Z('   The attributes plotted (radius, angle of apastron, etc) can be selected');
   Z('or unselected by pressing the key for the first letter of the name, thus the');
   Z('plot of the successive values for the Apastron may be suppressed by pressing');
   Z('the A key, and so on. The plots appear as separate dots for each value, but if');
   Z('you prefer Joined-up plots, pressing the J key will switch states.');
   Z('   The S key switches between Stepwise and continual execution; pressing some');
   Z('other key (e.g. Return) then advances the calculation one step each time.');
   Z('   Everything depends on the initial state, and a distressingly long list of');
   Z('parameters only begins to explore the opportunities, as follows:');
   Z('');
   Z('   YearLength: days in the planet''s year, e.g. 1000');
   Z('   PlanetMass: as a fraction of the sun''s mass, e.g. 0.0125');
   Z('   AsteroidR:  as a fraction of the planet''s distance from the C of M');
   Z('   AsteroidA:  angle with the x-axis (in degrees)');
   Z('   AsteroidRV: radial velocity as a factor of the circular orbit velocity');
   Z('   AsteroidCV: circular orbit velocity factor');
   Z('   Style:      E = Euler, M = Euler 2''nd, R = Runge-Kutta.');
   Z('   SunMotion:  W = wobble about C of M, F = (improperly) fixed at C of M.');
   Z('');
   Z('   You need not supply all of these, but as they are not named, there can be');
   Z('no gap in the list. Thus, if you supply the third parameter then you must');
   Z('also supply the first and second, but need not supply those past the third.');
   Z('If no parameters are offered, the default is equivalent to');
   Z('');
   Z('   WANDER 1000 0.15  0.5 0  0.0 -0.75  R W');
   Z('');
   Z('   This will use the classic fourth-order Runge-Kutta scheme for numerical');
   Z('integration of a differential equation for the case where a massive planet');
   Z('(the Earth''s mass is 1/300000 of the mass of the Sun) orbits in a fixed');
   Z('circle having a thousand one-day steps, and a (massless) asteroid starts off');
   Z('on the x-axis halfway between the planet and the centre of mass with an');
   Z('initial velocity straight down of three quarters of the speed a circular orbit');
   Z('of that radius would require in the absence of planetary perturbations.');
   Z('');
   Z('   Don''t forget the leading 0 in 0.15 that turbo pascal demands...');
   Z('   ESC to quit.');
  END;

 Procedure Reject(Gripe: anystring);
  BEGIN
   Writeln;
   Writeln('Unsavoury: ',Gripe);
   Writeln;
   Grunt(3);
   Halt;
  END;
 Const Usage: array[1..8] of string = (
  'Steps in a planetary year',
  'Planetary mass ratio',
  'Asteroid''s initial radial distance',
  'Asteroid''s initial angular position',
  'Asteroid''s initial outwards velocity',
  'Asteroid''s initial orbital velocity',
  'Numerical Integration Method',
  'Fixed or Wobbling Sun position');
 Procedure Scrog(i: integer; var v: grist);
  var hic: integer;
  BEGIN
   hic:=-666;
   if paramstr(i) <> '' then Val(Paramstr(i),v,hic);
   if hic <> 0 then Reject(paramstr(i) + ' for ' + usage[i]);
  END;
 Function ScrogT(i: integer; var n: integer; List: string): boolean;
  var c: char;
  var stupid: string[1];
  BEGIN
   if paramstr(i) = '' then scrogt:=false
    else
     begin
      stupid:=copy(Paramstr(i),1,1);
      c:=char(hi(integer(stupid)));
      n:=Pos(upcase(c),List);
      if n <= 0 then Reject(paramstr(i) + ' not one of ' + list + ' for ' + usage[i]);
      scrogt:=true;
     end;
  END;


{$F+} Function HeapFull(Size: word): integer; {$F-}
       Begin HeapFull:=1; End; {Sez "If full, return a null pointer" to GetMem.}
{Damnit, Turbo pascal's pointer using procedures don't check for null pointers!}
 var i: Integer;
 BEGIN {The main programme at last.}
  HeapError:=@HeapFull;                {Memory shortages?}
  AsItWas:=LastMode;
  Writeln('                       A Wanderer in an unstable orbit.');
  Style:=3;
  Wobble:=true;
  Year:=1000;
  SM:=1; PM:=0.15;
  AR:=0.5; AA:=0;
  ARV:=0; ACV:=-0.75;
  if paramcount > 0 then
   begin
    if paramstr(1) = '?' then begin Grunt(1); exit; end;
    Scrog(1,year); year:=round(year); {Whole steps only!}
    Scrog(2,PM);
    Scrog(3,AR);
    Scrog(4,AA);
    Scrog(5,ARV);
    Scrog(6,ACV);
    if ScrogT(7,Style,'EMR') then style:=max(1,min(style,3));
    if ScrogT(8,i,'FW') then Wobble:=i = 2;
   end;
  AA:=Pi*AA/180;
  PrepareTheCanvas;
  WanderAlong;
  TextMode(AsItWas);
 END.
