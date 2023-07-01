{$B- Early and safe resolution of  If x <> 0 and 1/x...}
Program LangtonsAnt; Uses CRT;
{Perpetrated by R.N.McLean (whom God preserve), Victoria University, December MMXV.}
 Var AsItWas: record mode: word; ta: word; end;
 Var LastLine,LastCol: byte;

 Procedure Swap(var a,b: integer);	{Oh for a compiler-recognised statement.}
  var t: integer;			{Such as A=:=B;}
   Begin
    t:=a; a:=b; b:=t;
   End;

 var Stepwise: boolean;
 Var Cell: Array[1..80,1..50] of byte;	{The screen is of limited size, alas.}
 Var x,y,Step: integer;		{In the absence of complex numbers,}
 Var dx,dy: integer;		{And also of array action statements.}

 Procedure Croak(Gasp: string);	{Exit message...}
  Begin
   GoToXY(1,12); TextColor(Yellow);	{Reserve line twelve.}
   WriteLn(Gasp,' on step ',Step,' to (',x,',',y,')');
   HALT;
  End;

 Procedure Harken;		{Waits for a keystroke.}
  var ch: char;			{The character. Should really be 16-bit.}
  Begin
   ch:=ReadKey;			{Fancy keys evoke double characters. I don't care.}
   if (ch = 'S') or (ch = 's') then Stepwise:=not Stepwise	{Quick, slow, quick, quick, slow...}
    else if ch = #27 then Croak('ESC!');	{Or perhaps, enough already!}
  End;				{Fancy keys will give a twostep.}
 Procedure Waitabit;		{Slows the action.}
  Begin
   if Stepwise or KeyPressed then Harken;	{Perhaps a change while on the run.}
  End;	{of Waitabit.}

 Procedure Turn(way:integer);	{(dx,dy)*(0,w) = (-w*dy,+w*dx)}
  Begin
   Swap(dx,dy);			{In the absence of complex arithmetic,}
   dx:=-way*dx; dy:=way*dy;	{Do this in two stages.}
  End;

 const Arrow: array[-1..+1,-1..+1] of integer	{Only four entries are of interest.}
  = ((1,27,3),(25,5,24),(7,26,9));		{For the four arrow symbols.}
 Procedure ShowDirection(Enter,How: byte);	{Show one.}
  Begin
   GoToXY(x,LastLine - y + 1);	{(x,y) position, in Cartesian style.}
   TextBackground(Enter);	{The value in Cell[x,y] may have been changed.}
   TextColor(How);
   Writeln(chr(Arrow[dx,dy]));	{Not an ASCII control character, but an arrow symbol.}
   Waitabit;			{Having gone to all this trouble.}
  End;
 Procedure ShowState;		{Special usage for line two of the screen.}
  Begin
   GoToXY(1,2); TextBackground(LightGray); TextColor(Black);
   Write(Step:5,' (',x:2,',',y:2,') ');
   TextColor(Yellow);		{Yellow indicates the direction in mind.}
   Write(chr(Arrow[dx,dy]));	{On *arrival* at a position.}
  End;

 Var i,j: integer;		{Steppers. No whole-array assault as in Cell:=LightGray;}
 var Enter: byte;		{Needed to remember the cell state on arrival.}
 BEGIN
  AsItWas.mode:=LastMode;	{Grr. I might want to save the display content too!}
  AsItWas.ta:=TextAttr;		{Not just its colour and style.}
  TextMode(C80+Font8x8);	{Crazed gibberish gives less unsquare character cells, and 80x50 of them.}
  LastLine:=Hi(WindMax);	{ + 1 omitted, as a write to the last line scrolls the screen up one...}
  LastCol:=Lo(WindMax) + 1;	{Counting starts at zero, even though GoToXY starts with one.}
  x:=LastCol div 2;		{Start somewhere middleish.}
  y:=LastLine div 2;		{Consider (x,y) as being (0,0) for axes.}
  dx:=+1; dy:=0;		{Initial direction.}
  TextBackground(LightGray);	{"White" is not valid for background colour.}
  TextColor(Black);		{This will show up on a light background.}
  ClrScr;			{Here we go.}

  WriteLn('Langton''s Ant, on x = 1:',LastCol,', y = 1:',LastLine);
  ShowState;					{Where we start.}
  WriteLn; TextColor(Black);
  WriteLn('Press a key for each step.');	{Some encouragement.}
  WriteLn('"S" to pause each step or not.');
  WriteLn('ESC to quit.');

  for i:=1 to LastLine do begin GoToXY(x,i); Write('|'); end;			{Draw a y-axis.}
  for i:=1 to LastCol do begin GoToXY(i,LastLine - y + 1); Write('-'); end;	{And x.}
  gotoxy(1,6);	{Can't silence the cursor!}

  for i:=1 to LastCol do	{Prepare the cells.}
   for j:=1 to LastLine do	{One by one.}
    Cell[i,j]:=LightGray;	{Cell:=LightGray. Sigh.}

  Stepwise:=true;		{The action is of interest.}
  for Step:=1 to 12000 do	{Here we go.}
   if (x <= 0) or (x > LastCol) or (y <= 0) or (y > LastCol) then Croak('Out of bounds')
    else				{We're in a cell.}
     begin				{So, inspect it.}
      if Stepwise or (Step mod 10 = 0) then ShowState	{On arrival.}
       else if KeyPressed then Harken;			{If we're not pausing, check for a key poke.}
      Enter:=cell[x,y];					{This is what awaits the feet.}
      if Stepwise then ShowDirection(Enter,Yellow);	{Current direction, about to be changed.}
      case cell[x,y] of					{So, what to do?}
   LightGray: begin Cell[x,y]:=Black;     Turn(-1); end;{White. Make black and turn right.}
       Black: begin Cell[x,y]:=LightGray; Turn(+1); end;{Black. Make white and turn left.}
      end;						{Having decided,}
      if Stepwise then ShowDirection(Enter,Green);	{Show the direction about to be stepped.}
      GoToXY(x,LastLine - y + 1);	{Screen location (column,line) for (x,y)}
      TextBackground(Cell[x,y]);	{Change the state I'm about to leave.}
      Write(' ');			{Foreground colour irrelevant for spaces.}
      x:=x + dx; y:=y + dy;		{Make the step!}
     end;			{On to consider our new position.}

  Croak('Finished');		{That was fun.}

 END.
