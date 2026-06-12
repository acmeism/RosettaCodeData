{$N+ Crunch only the better sort of numbers, thanks.}
Program Swirl; Uses Graph, Crt;
{   Calculates and displays orbits strongly twisted by gravity, as described
 in the article by J. Gallmeier et al, in Sky & Telescope, October 1995, which
 included the source code of a programme written in basic, so some changes here.
    An actual pulsar in orbit about another compact body has parameters
 EC = .61713 and SG = .000025, resulting in a precession of .0037 degrees/orbit.
    More fierce relativistic effects involve close passages by a black hole.
 A dark disc appears corresponding to the event horizon diameter for a
 non-rotating black hole (the screen is normally 'black' so the black hole is
 not depicted as black) and a circle at twice its diameter is drawn; particles
 venturing within that bound will not repeat their orbit as they are either on
 the way down the drain, or else on a hyperbolic flypast.
    This calculation is for orbits that continue indefinitely, and the authors
 have used the classic Runge-Kutta fourth-order method to numerically integrate
 the relativistic equations twisting the axes of the orbit.}

{Perpetrated by R.N.McLean (whom God preserve), Victoria University, Nov. VMM.}

 Type Grist = {$IFOPT N+} extended {$ELSE} real {$ENDIF};
 const esc = #27;
 var colour,lastcolour,xmax,ymax,txtheight: integer;
 var stretch: grist;
 Type AnyString = string[80];

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

 Procedure Rogbiv;
  BEGIN;
   SetPalette( 0,Black);
   SetPalette( 1,DarkGray);  {Looks navy blue to me.}
   SetPalette( 2,Blue);
   SetPalette( 3,LightBlue);
   SetPalette( 4,LightCyan);
   SetPalette( 5,Cyan);
   SetPalette( 6,LightGreen);
   SetPalette( 7,Green);
   SetPalette( 8,LightGray); {Looks light brown to me.}
   SetPalette( 9,Yellow);
   SetPalette(10,Brown);     {Looks yellow to me.}
   SetPalette(11,Red);
   SetPalette(12,LightRed);
   SetPalette(13,Magenta);
   SetPalette(14,LightMagenta);
   SetPalette(15,White);
  END; {Of Rogbiv.}

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
   if LastColour = 15 then Rogbiv;
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

 Var nstep: longint;
 Procedure SplotStep;
  BEGIN
   Splot(xmax,0 + TxtHeight,'Stepcount: ' + ifmt(nstep));
  END;


 Var EC,SG,SS,SA: grist;
 Var n: longint;
 Procedure PrecessRelativistically;
  var
   SX,SY,
   C0,C2,RH,
   Q,SN,QN,DN,HN,DP,SP,
   K1,K2,K3,K4,L1,L2,L3,L4: grist;
  var xc,yc,px,py: integer;
  Procedure Fullturn;
   BEGIN
    Line(xc,yc, round(PX),round(PY));
    n:=n + 1;
    Splot(xmax,0,'Completed orbits ' + ifmt(n));
    SplotStep;
    if n = 1 then            {First time round?}
     begin                   {Yep. DP and DN straddle zero. Find S where D = 0.}
      SA:=(SP - DP*(SN - SP)/(DN - DP))*180/Pi - 360;
      Splot(xmax,ymax - txtheight,'Precession per orbit ' + ffmt(SA,15,5) + 'ø');
     end;                    {y:x=0 given (x1,y1) and (x2,y2):  y = y1 - x1*(y2 - y1)/(x2 - x1)}
    colour:=colour + 1;
    if colour > Lastcolour then colour:=3;
    setcolor(colour);
   END;
  Var ch: char;
  BEGIN
   Splot(0,0,'Eccentricity ' + ffmt(EC,9,6));
   Splot(0,ymax - txtheight,'Relativistic Factor ' + ffmt(SG,9,6));
   Splot(xmax,0 + 2*txtheight,'StepSize ' + ffmt(SS,8,3));
   xc:=xmax div 2; yc:=ymax div 2;
   n:=0; nstep:=0;
   SS:=0.0009*(SS - 0.9)*(1 - 0.9*exp(10*EC - 9)); {Step size stuff...}
   SY:=yc/(1 + EC);  SX:=SY*stretch;
   C0:=(1 - SG*(3 + EC*EC)/(6 + 2*EC))/(1 - EC*EC);
   RH:=SG*(1 - EC*EC)/(3 + EC);
   C2:=1.5*RH;
   SA:=0;
   Colour:=1; SetColor(Colour);    Circle(xc,yc,round(SX*RH));
   SetFillStyle(SolidFill,Colour); FloodFill(xc,yc,Colour);
                                   Circle(xc,yc,round(SX*RH*2));
   Colour:=2; SetColor(Colour); Line(0,yc, xmax,yc); Line(xc,0, xc,ymax);
   Colour:=3; SetColor(Colour);
   SN:=0; QN:=1/(1 + EC); DN:=0;
   repeat
    DP:=DN; SP:=SN;
    HN:=SS*QN*QN;
    Q:=QN;        K1:=(C0 - Q + C2*Q*Q)*HN; L1:=HN*DN;
    Q:=QN + L1/2; K2:=(C0 - Q + C2*Q*Q)*HN; L2:=HN*(DN + K1/2);
    Q:=QN + L2/2; K3:=(C0 - Q + C2*Q*Q)*HN; L3:=HN*(DN + K2/2);
    Q:=QN + L3;   K4:=(C0 - Q + C2*Q*Q)*HN; L4:=HN*(DN + K3);
    QN:=QN + (L1 + (L2 + L3)*2 + L4)/6;
    DN:=DN + (K1 + (K2 + K3)*2 + K4)/6;
    SN:=SN + HN;
    px:=xc + Round(SX*cos(SN)/QN); py:=yc - Round(SY*sin(SN)/QN);
    PutPixel(px,py,Colour);
    nstep:=nstep + 1;
    if (DN > 0) and (DP < 0) then fullturn
     else if nstep mod 250 = 0 then splotstep;
   until keypressed;
   if readkey <> esc then repeat until keypressed;
  END; {Of PrecessRelativistically.}

 Procedure Grunt;
  BEGIN
   WriteLn('Draws orbits under relativistic conditions.');
   WriteLn('Activate with two parameters:');
   WriteLn('   Orbital Eccentricity (0 to 0ù9),');
   WriteLn('   Relativistic factor  (0 to 0ù999)');
   WriteLn('An optional third parameter is the step size (1 to 10, e.g. 5).');
   WriteLn('(If no parameters are supplied, an example run results)');
   WriteLn('Eg.  Swirl 0.5 0.5 5');
   WriteLn('Don''t forget the leading zeroes that turbo pascal demands...');
   WriteLn('ESC to quit.');
  END;

 Procedure Reject(Gripe: anystring);
  BEGIN
   Writeln;
   Writeln('Unsavoury: ',Gripe);
   Writeln;
   Grunt;
   Halt;
  END;

 Var AsItWas: word;
 Var i: integer;
 Var Hic: array[1..3] of integer;
 BEGIN
  AsItWas:=LastMode;
  Writeln('                       Precession of Elliptical Orbits.');
  EC:=0.8; SG:=0.3826057; SS:=5;        {These values result in 72 degrees/orbit...}
  if paramcount > 0 then
   begin
    if paramstr(1) = '?' then begin Grunt; exit; end;
    Val(ParamStr(1),EC,hic[1]);
    Val(ParamStr(2),SG,hic[2]);
    hic[3]:=0; if paramcount >= 3 then Val(paramstr(3),SS,Hic[3]);
    for i:=1 to 3 do if hic[i] > 0 then Reject('Parameter ' + ifmt(i) + ': ' + paramstr(i));
   end;
  if (ec < 0) or (ec >= 1) then Reject('an eccentricity of ' + ffmt(ec,15,5));
  if (sg < 0) or (sg >= 1) then Reject('a relativistic factor of ' + ffmt(sg,15,5));
  if ss <= 0 then Reject('a step size of ' + ffmt(ss,15,5));
  PrepareTheCanvas;
  PrecessRelativistically;
  TextMode(AsItWas);
  WriteLn('Orbital eccentricity:',EC:15:5);
  WriteLn('Relativistic factor :',SG:15:5);
  WriteLn('Precession per orbit:',SA:15:5);
  WriteLn('Orbits completed: ',n);
  WriteLn('Calculation steps:',nstep);
 END.
