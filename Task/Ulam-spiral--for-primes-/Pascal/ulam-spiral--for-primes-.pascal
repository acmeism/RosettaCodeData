Program Ulam; Uses crt;
{Concocted by R.N.McLean (whom God preserve), ex Victoria university, NZ.}
{$B- evaluate boolean expressions only so far as necessary.}
{$R+ range checking...}

 FUNCTION Trim(S : string) : string;
  var L1,L2 : integer;
 BEGIN
  L1 := 1;
  WHILE (L1 <= LENGTH(S)) AND (S[L1] = ' ') DO INC(L1);
  L2 := LENGTH(S);
  WHILE (S[L2] = ' ') AND (L2 > L1) DO DEC(L2);
  IF L2 >= L1 THEN Trim := COPY(S,L1,L2 - L1 + 1) ELSE Trim := '';
 END; {Of Trim.}

FUNCTION Ifmt(Digits : integer) : string;
 var  S : string[255];
 BEGIN
  STR(Digits,S);
  Ifmt := Trim(S);
 END; { Ifmt }
 Function min(i,j: integer): integer;
  begin
   if i <= j then min:=i else min:=j;
  end;
 Procedure Croak(Gasp: string);        {A lethal word.}
  Begin
   WriteLn;
   WriteLn(Gasp);
   HALT;                   {This way to the egress...}
  End;
 var ScreenLine,ScreenColumn: byte;	{Line and column position.}
{=========================enough support===================}
 const Mstyle = 6;	{Display different results.}
 const StyleName: array[1..Mstyle] of string = ('IsPrime','First Prime Factor Index',
  'First Prime Factor','Number of Prime Factors',
  'Sum of Prime Factors','Sum of Proper Factors');
 const OrderLimit = 49; Limit2 = OrderLimit*OrderLimit;		{A 50-line screen has room for a heading.}
 var Tile: array[1..OrderLimit,1..OrderLimit] of integer; 	{Alas, can't put [Order,Order], only constants.}
 var FirstPrimeFactorIndex,FirstPrimeFactor,NumPFactor,SumPFactor,SumFactor: array[1..Limit2] of integer;
 const enuffP = 17;	{Given the value of Limit2.}
 const Prime: array[1..enuffP] of integer = (1,2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53);
 Procedure Prepare;	{Various arrays are to be filled for the different styles.}
  var i,j,p: integer;
  Begin
   for i:=1 to limit2 do	{Alas, can't just put A:=0;}
    begin			{Nor clear A;}
     FirstPrimeFactorIndex[i]:=1;	{Prime[1] = 1, so this means no other divisor.}
     FirstPrimeFactor[i]:=0;
     NumPFactor[i]:=0;
     SumPFactor[i]:=0;
     SumFactor[i]:=1;		{1 is counted as a proper factor.}
    end;
   FirstPrimeFactorIndex[1]:=0;	{Fiddle, as 1 is not a prime number.}
   SumFactor[1]:=0;		{N is not a proper factor of N, so 1 has no proper factors...}
   for i:=2 to enuffP do	{Prime[1] = 1, Prime[2] = 2, so start with i = 2.}
    begin
     p:=Prime[i];
     j:=p + p;
     while j <= Limit2 do
      begin
       if FirstPrimeFactorIndex[j] = 1 then FirstPrimeFactorIndex[j]:=i;
       if FirstPrimeFactor[j] = 0 then FirstPrimeFactor[j]:=p;
       SumPFactor[j]:=SumPFactor[j] + p;
       inc(NumPFactor[j]);
       j:=j + p;
      end;
    end;
   for i:=2 to Limit2 div 2 do	{Step through all possible proper factors.}
    begin			{N is not a proper factor of N, so start at 2N,}
     j:=2*i;	 		{for which N is a proper factor of 2N.}
     while j <= Limit2 do	{Sigh. for j:=2*i:Limit2:i do ... Next i;}
      begin
       SumFactor[j]:=SumFactor[j] + i;
       j:=j + i;
      end;
    end;
  End;	{Enough preparation.}

 const enuffC = 11;	{Perhaps the colours will highlight interesting patterns.}
 const colour:array[0..enuffC] of byte = (black,white,LightRed,
  LightMagenta,Yellow,LightGreen,LightCyan,LightBlue,LightGray,
  Red,Green,DarkGray);		{Colours on the screen don't always match their name!}

 Procedure UlamSpiral(Order,Start,Style: integer);	{Generate the numbers, then display.}
  Function Encode(N: integer): integer;	{Acording to Style, choose a result to show.}
   Begin
    if N <= 1 then Encode:=0
     else
      case style of
     1:if FirstPrimeFactorIndex[N] = 1 then Encode:=1 else Encode:=0;	{1 = Prime.}
     2:Encode:=FirstPrimeFactorIndex[N];
     3:Encode:=FirstPrimeFactor[N];
     4:Encode:=NumPFactor[N];
     5:Encode:=SumPFactor[N];
     6:Encode:=SumFactor[N];
      end;
   End;	{So much for encoding.}
  var Place,Way: array[1..2] of integer;	{Complex numbers.}
  var m,	{Middle.}
      N,	{Counter.}
      length,	{length of a side.}
      lunge,	{two lunges for each length.}
      step	{steps to make up a lunge of some length.}
      : integer;
  var i,j: integer;	{Steppers.}
  var code,it: integer;	{Mess with the results.}
  label XX;		{Escape the second lunge.}
  var OutF: text;	{Utter drivel. It is a disc file.}
  Begin
   Write('Ulam Spiral, order ',Order,', start ',Start,', style ',style);	{Start the heading.}
   if style <= 0 then Croak('Must be a positive style');
   if style > Mstyle then croak('Last known style is '+ifmt(Mstyle));
   if Order > OrderLimit then Croak('Array OrderLimit is order '+IFmt(OrderLimit));
   if Order mod 2 <>1 then Croak('The order must be an odd number!');
   writeln(': ',StyleName[Style]);	{Finish the heading. The pattern starts with line two.}
   Assign(OutF,'Ulam.txt'); Rewrite(OutF); Writeln(OutF,'Ulam spiral: the codes for ',StyleName[style]);
   m:=order div 2 + 1;		{This is why Order must be odd.}
   Place[1]:=m; Place[2]:=m;	{Start at the middle.}
   way[1]:=1; way[2]:=0;	{Initial direction is along the x-axis.}
   n:=Start;
   for length:=1 to Order do	{Advance through the lengths.}
    for lunge:=1 to 2 do		{Two lunges for each length.}
     begin
      for step:=1 to length do			{Make the steps.}
       begin
        Tile[Place[1],Place[2]]:=N;
        for i:=1 to 2 do Place[i]:=Place[i] + Way[i];   {Place:=Place + Way;}
        N:=N + 1;
       end;
      if N >= Order*Order then goto XX;	{Each corner piece is part of two lunges.}
      i:=Way[1]; Way[1]:=-Way[2]; Way[2]:=i;	{Way:=Way*(0,1) in complex numbers: (x,y)*(0,1) = (-y,x).}
     end;
XX:for i:=order downto 1 do     {Output: Lines count downwards, y runs upwards.}
    begin			{The first line is the topmost y.}
     for j:=1 to order do	{(line,column) = (y,x).}
      begin				{Work along the line.}
       it:=Tile[j,i];			{Grab the number.}
       code:=Encode(it);		{Presentation scheme.}
       Write(OutF,'(',it:4,':',code:2,')');	{Debugging...}
       if FirstPrimeFactorIndex[it] > 1 then TextBackGround(Black)	{Not a prime.}
        else if it = 1 then TextBackGround(Black)	{Darkness for one, also.}
         else TextBackGround(White);		{A prime number!}
       TextColor(Colour[min(code,enuffC)]);	{A lot of fuss for this!}
       {Write(code:2);}
       {Write(it:3);}
       if it <= 9 then write(it) else Write('*');	{Thus mark the centre.}
      end;					{Next position along the line.}
     if i > 1 then WriteLn;		{Ending the last line would scroll the heading up.}
     WriteLn(OutF);			{But this is good for the text file.}
    end;			{On to the next line.}
    Close(OutF);		{Finished with the trace.}
{Some revelations to help in choosing a colour sequence.}
    ScreenLine:=WhereY; ScreenColumn:=WhereX;	{Gibberish to find the location.}
    if Style > 1 then	{Only the fancier styles go beyond 0 and 1.}
     begin			{So explain only for them.}
      GoToXY(ScreenColumn + 1,ScreenLine - 4);		{Unused space is to the right.}
      TextColor(White); write('Colour sequence');	{Given 80-column displays.}
      GoToXY(ScreenColumn + 1,ScreenLine - 3);		{And no more than 50 lines.}
      for i:=1 to enuffC do begin TextColor(Colour[i]); write(i); end;	{My sequence.}
      GoToXY(ScreenColumn + 1,ScreenLine - 2);
      TextColor(White); write('From options');
      GoToXY(ScreenColumn + 1,ScreenLine - 1);
      for i:=1 to 15 do begin TextColor(i);write(i); end;		{The options.}
     end;
  End;   {of UlamSpiral.}

 var start,wot,order: integer;	{A selector.}
 BEGIN	{After all that.}
  TextMode(Lo(LastMode) + Font8x8);	{Gibberish sets 43 lines on EGA and 50 on VGA.}
  ClrScr; TextColor(White);		{This also gives character blocks that are almost square...}
  WriteLn('Presents consecutive integers in a spiral, as per Stanislaw Ulam.');
  WriteLn('Starting with 1, runs up to Order*Order.');
  Write('What value for Order? (Limit ' + Ifmt(OrderLimit),'): ');
  ReadLn(Order);			{ReadKey needs no "enter", but requires decoding.}
  if (order < 1) or (order > OrderLimit) then Croak('Out of range!');	{Oh dear.}
  Prepare;
  wot:=1;	{The original task.}
  Repeat		{Until bored?}
   ClrScr;			{Scrub any previous stuff.}
   UlamSpiral(Order,1,wot);		{The deed!}
   GoToXY(ScreenColumn + 1,ScreenLine);		{Note that the last WriteLn was skipped.}
   TextColor(White); Write('Enter 0, or 1 to '+Ifmt(Mstyle),': ');	{Wot now?}
   ReadLn(wot);						{Receive.}
  Until (wot <= 0) or (wot > Mstyle);		{Alas, "Enter" must be pressed.}
 END.
