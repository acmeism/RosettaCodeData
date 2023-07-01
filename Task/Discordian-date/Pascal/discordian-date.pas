program ddate;
{
This program is free software, it's done it's time
and paid for it's crime. You can copy, edit and use this
software under the terms of the GNU GPL v3 or later.

Copyright Pope Englebert Finklestien,
On this day Boomtime, the 71st day of Confusion in the YOLD 3183

This program will print out the current date in Erisian format as specified in

                  P R I N C I P I A   D I S C O R D I A

If you run it with a date it the command line in european format (dd mm yy) it
will print the equvolent Discordian date. If you omit the year and  month the
current Anerisiean month and year as assumed.


POPE Englebert Finklestien.
}
uses Sysutils;

var
  YY,MM,DD : word;
  YOLD : Boolean;
  Hedgehog: integer;
  Eris: string;
  snub: string;
  chaotica: string;
  midget: string;
  bob: string;


  Anerisiandaysinmonth: array[1..12] of integer = (31,28,31,30,31,30,31,31,30,31,30,31);



procedure anerisiandate;
{ tHIS JUST GETS THE DATE INTO THE  DD,MM,YY VARIABLES }
begin
    DeCodeDate(date,yy,mm,dd);
end;

procedure BORIS;
{ This just tests to see if we are in a leap year }
var
  snafu : boolean;
begin
  snafu := False;
  if (yy mod 4 = 0) then snafu := True;
  if ((yy mod 100 = 0) and (yy mod 400 <> 0)) then snafu := False;
  if ((snafu) and (mm = 2 ) and (dd=29)) then YOLD := True;
end;

function hodgepodge: integer;
{ This returns the total number of days since the year began.
It doesn't bother with leap years at all.
I get a wierd optical illusion looking at the until in this }
var
  fnord : integer;
begin
   Hedgehog := 1;
   hodgepodge := 0;
   fnord :=0;
   if (mm > 1) then repeat
             fnord := fnord + Anerisiandaysinmonth[Hedgehog];
             Hedgehog := Hedgehog +1;
       until Hedgehog = mm;
   fnord := fnord + dd;
   hodgepodge := fnord;
 end;


function treesaregreen(): string;
{Returns the YOLD as a string}

begin
    treesaregreen := IntTOStr(yy+1166);
end;


procedure GRAYFACE;
{This calculates everything, but does not bother much about leap years}
var
   wrestle: integer;
   Thwack: string;
begin
    Hedgehog := hodgepodge;
    wrestle := 0;
    Thwack := 'th';
    {set bob to the name of the holyday or St. Tibs day }
    bob := 'St. Tibs Day';
    if (Hedgehog = 5 )  then bob := 'Mungday';
    if (Hedgehog = 50 ) then bob := 'Chaoflux';
    if (Hedgehog = 78 ) then bob := 'Mojoday';
    if (Hedgehog = 123) then bob := 'Discoflux';
    if (Hedgehog = 151) then bob := 'Syaday';
    if (Hedgehog = 196) then bob := 'Confuflux';
    if (Hedgehog = 224) then bob := 'Zaraday';
    if (Hedgehog = 269) then bob := 'Bureflux';
    if (Hedgehog = 297) then bob := 'Maladay';
    if (Hedgehog = 342) then bob := 'Afflux';
    {Not doing things the usual way
    Lets find the week day and count the number of
	5 day weeks all at the same time}
    while (Hedgehog > 5) do begin
      Hedgehog := Hedgehog -5;
      wrestle := Wrestle + 1;
    end;
    if (Hedgehog = 1) then snub := 'Sweetmorn'  ;
    if (Hedgehog = 2) then snub := 'BoomTime';
    if (Hedgehog = 3) then snub := 'Pungenday';
    if (Hedgehog = 4) then snub := 'Prickle-Prickle';
    if (Hedgehog = 5) then snub := 'Setting Orange';
	{Now to set the Season name}
    chaotica:='The Aftermath';
    if (wrestle <=57) then chaotica := 'Bureaucracy';
    if ((wrestle = 58) and (Hedgehog < 3)) then chaotica := 'Bureaucracy';
    if (wrestle <= 42) then chaotica := 'Confusion';
    if ((wrestle = 43) and (Hedgehog < 5)) then chaotica := 'Confusion';
    if (wrestle <=28) then chaotica := 'Discord';
    if ((wrestle = 29) and (Hedgehog < 2)) then chaotica := 'Discord';
    if (wrestle <=13) then chaotica := 'Chaos';
    if ((wrestle = 14) and (Hedgehog < 4)) then chaotica := 'Chaos';

	{Now all we need the day of the season}
    wrestle := (wrestle*5)+Hedgehog;
    while (wrestle >73) do wrestle := wrestle -73;
	{pick the appropriate day postfix, allready set to th}
    if (wrestle in [1,21,31,41,51,61,71]) then Thwack:='st';
    if (wrestle in [2,22,32,42,52,62,72]) then Thwack:='nd';
    if (wrestle in [3,23,33,43,53,63,73]) then Thwack:='rd';
	{Check to see if it is a holy day, if so bob will have
	the right holyday name already, including St Tibs Day}
    if (wrestle in [5,50]) then YOLD := True;
	{I love this line of code}
    midget := IntToStr(wrestle) + Thwack;
end;


{The main program starts here}
begin
    anerisiandate;
    if (ParamCount >=1) then dd := StrTOInt(ParamStr(1));
    if (ParamCount >=2) then mm := StrToInt(ParamStr(2));
    if (ParamCount =3) then yy := StrToInt(ParamStr(3));
    BORIS;
    GRAYFACE;
	{ The only thing to bother about is holy days and St Tibs day }
    Eris := 'Today is: ' + snub +' the ' + midget +' day of the season of ' + chaotica;
    if (YOLD) then begin
	    Eris := 'Celebrate for today, ' + snub + ' the ' + midget + ' day of ' +chaotica + ' is the holy day of ' + bob;
    end;
	{The only place we deal with St. Tibs Day}
    if ((YOLD) and ((mm=2) and (dd=29))) then Eris := 'Celebrate ' + bob + ' Chaos';
	{This next line applies to all possibilities}
    Eris := Eris + ' YOLD ' + treesaregreen;
    WriteLn(Eris);
end.
