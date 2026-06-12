PROGRAM Periode;
//https://entwickler-ecke.de/viewtopic.php?t=108866
//checking lenght and start period of 1/value
//using Euler Phi
{$IFDEF FPC}
  {$MODE Delphi}
  {$OPTIMIZATION ON,ALL}
{$else}
  {$Apptype Console}
{$ENDIF}
uses
  sysutils;

const
  cTestVal : array[0..11] of LongInt = (2,5,3,7,13,17,60,149,555,625,5261,High(longint));
  cBase = 10;
  PRIMFELDOBERGRENZE = 6542;
  {Das sind alle Primzahlen bis 2^16}
  {Das reicht fuer alle Primzahlen bis 2^32}
type
   tPrimFeld = array [1..PRIMFELDOBERGRENZE] of Word;
   tFaktorPotenz = record
                     Faktor,
                     Potenz  : DWord;
                   end;
   //2*3*5*7*11*13*17*19*23  *29 > DWord also maximal 9 Faktoren
   tFaktorFeld =  array [1..9] of TFaktorPotenz;//DWord
// tFaktorFeld =  array [1..15] of TFaktorPotenz;//QWord
   tFaktorisieren = class(TObject)
                      private
                        fFakZahl   : DWord;
                        fNominator : DWord;
                        fFakBasis  : DWord;
                        fFakAnzahl : Dword;
                        fAnzahlMoeglicherTeiler : Dword;
                        fEulerPhi  : DWORD;
                        fStartPeriode : DWORD;
                        fPeriodenLaenge  : DWORD;
                        fTeiler    : array of DWord;
                        fFaktoren  : tFaktorFeld;
                        fBasFakt   : tFaktorFeld;
                        fPrimfeld  : tPrimFeld;

                        procedure PrimFeldAufbauen;
                        procedure Fakteinfuegen(var Zahl:Dword;inFak:Dword);
                        function  BasisPeriodeExtrahieren(var inZahl:Dword):DWord;
                        procedure NachkommaPeriode(var OutText: String);
                      public
                        constructor create; overload;
                        function  Prim(inZahl:Dword):Boolean;
                        procedure AusgabeFaktorfeld(n : DWord);
                        procedure Faktorisierung (inZahl: DWord);
                        procedure TeilerErmitteln;
                        procedure PeriodeErmitteln(inZahl:Dword);
                        function BasExpMod( b, e, m : Dword) : DWord;

                     property
                        EulerPhi : Dword read fEulerPhi;
                     property
                        PeriodenLaenge: DWord read fPeriodenLaenge ;
                     property
                        StartPeriode: DWord read fStartPeriode ;
                    end;

constructor tFaktorisieren.create;
begin
  inherited;
  PrimFeldAufbauen;

  fFakZahl  := 0;
  fNominator := 1;
  fFakBasis := cBase;
  Faktorisierung(fFakBasis);
  fBasFakt := fFaktoren;

  fFakZahl := 0;
  fEulerPhi := 1;
  fPeriodenLaenge :=0;
  fFakZahl := 0;
  fFakAnzahl := 0;
  fAnzahlMoeglicherTeiler := 0;
end;

function tFaktorisieren.Prim(inZahl:Dword):Boolean;
{Testet auf PrimZahl}
var
  Wurzel,
  pos       : Dword;
Begin
  if fFakZahl = inZahl then
    begin
    result := (fAnzahlMoeglicherTeiler = 2);
    exit;
    end;
  result := false;
  if inZahl >1 then
    begin
    result := true;
    Pos := 1;
    Wurzel:= trunc(sqrt(inZahl));
    While fPrimFeld[Pos] <= Wurzel do
      begin
      if (inZahl mod fPrimFeld[Pos])=0 then
        begin
        result := false;
        break;
        end;
      inc(Pos);
      IF Pos > High(fPrimFeld) then
        break;
      end;
    end;
end;

Procedure tFaktorisieren.PrimFeldAufbauen;
{genearating list of primes}
const
  MAX = 65536;
var
  TestaufPrim,
  Zaehler,delta : Dword;

begin
Zaehler := 1;
fPrimFeld[Zaehler] := 2;
inc(Zaehler);
fPrimFeld[Zaehler] := 3;

delta := 2;
TestAufPrim:=5;
repeat
  if prim(TestAufPrim) then
    begin
    inc(Zaehler);
    fPrimFeld[Zaehler] := TestAufPrim;
    end;
  inc(TestAufPrim,delta);
  delta := 6-delta; // 2,4,2,4,2,4,2,
until (TestAufPrim>=MAX);

end; {PrimfeldAufbauen}

procedure tFaktorisieren.Fakteinfuegen(var Zahl:Dword;inFak:Dword);
var
  i : DWord;
begin
  inc(fFakAnzahl);
  with fFaktoren[fFakAnzahl] do
    begin
      fEulerPhi := fEulerPhi*(inFak-1);
    Faktor :=inFak;
    Potenz := 0;
    while (Zahl mod inFak) = 0 do
      begin
      Zahl := Zahl div inFak;
      inc(Potenz);
      end;
    For i := 2 to Potenz do
      fEulerPhi := fEulerPhi*inFak;
    end;
  fAnzahlMoeglicherTeiler:=fAnzahlMoeglicherTeiler*(1+fFaktoren[fFakAnzahl].Potenz);
end;

procedure tFaktorisieren.Faktorisierung (inZahl: DWord);
var
  j,
  og : longint;
begin
if fFakZahl = inZahl then
  exit;

fPeriodenLaenge := 0;
fFakZahl   := inZahl;
fEulerPhi  := 1;
fFakAnzahl := 0;
fAnzahlMoeglicherTeiler :=1;
setlength(fTeiler,0);

If inZahl < 2 then
  exit;
og := round(sqrt(inZahl)+1.0);
{Suche Teiler von inZahl}
for j := 1 to High(fPrimfeld) do
  begin
  If fPrimfeld[j]> OG then
    Break;
  if (inZahl mod fPrimfeld[j])= 0 then
    Fakteinfuegen(inZahl,fPrimfeld[j]);
  end;
If inZahl>1 then
  Fakteinfuegen(inZahl,inZahl);
TeilerErmitteln;
end; {Faktorisierung}

procedure tFaktorisieren.AusgabeFaktorfeld(n : DWord);
var
  i :integer;
begin
  if fFakZahl <> n then
    Faktorisierung(n);
  write(fAnzahlMoeglicherTeiler:5,' Faktoren ');

  For i := 1 to fFakAnzahl-1 do
    with fFaktoren[i] do
      IF potenz >1 then
        write(Faktor,'^',Potenz,'*')
      else
        write(Faktor,'*');
  with fFaktoren[fFakAnzahl] do
    IF potenz >1 then
      write(Faktor,'^',Potenz)
    else
      write(Faktor);
  writeln('  Euler Phi: ',fEulerPhi:12,PeriodenLaenge:12);
end;

procedure tFaktorisieren.TeilerErmitteln;
var
  Position : DWord;
  i,j : DWord;
  procedure FaktorAufbauen(Faktor: DWord;n: DWord);
  var
    i,
    Pot : DWord;
  begin
    Pot := 1;
    i := 0;
    repeat
      IF n > Low(fFaktoren) then
        FaktorAufbauen(Pot*Faktor,n-1)
      else
        begin
        FTeiler[Position] := Pot*Faktor;
        inc(Position);
        end;
      Pot := Pot*fFaktoren[n].Faktor;
      inc(i);
    until  i > fFaktoren[n].Potenz;
  end;

begin
  Position:= 0;
  setlength(FTeiler,fAnzahlMoeglicherTeiler);
  FaktorAufbauen(1,fFakAnzahl);
  //Sortieren
  For i := Low(fTeiler) to fAnzahlMoeglicherTeiler-2 do
    begin
    j := i;
    while (j>=Low(fTeiler)) AND (fTeiler[j]>fTeiler[j+1]) do
      begin
      Position := fTeiler[j];
      fTeiler[j] := fTeiler[j+1];
      fTeiler[j+1]:= Position;
      dec(j);
      end;
    end;
end;

function tFaktorisieren.BasisPeriodeExtrahieren(var inZahl:Dword):DWord;
var
 i,cnt,
 Teiler: Dword;
begin
  cnt := 0;
  result := 0;
  For i := Low(fBasFakt) to High(fBasFakt) do
    begin
    with fBasFakt[i] do
      begin
      IF Faktor = 0 then
        BREAK;
      Teiler := Faktor;
      For cnt := 2 to Potenz do
        Teiler := Teiler*Faktor;
      end;
    cnt := 0;
    while (inZahl<> 0) AND (inZahl mod Teiler = 0) do
      begin
      inZahl := inZahl div Teiler;
      inc(cnt);
      end;
    IF cnt > result then
      result := cnt;
    end;
end;

procedure tFaktorisieren.PeriodeErmitteln(inZahl:Dword);
var
  i,
  TempZahl,
  TempPhi,
  TempPer,
  TempBasPer: DWord;
begin
  Faktorisierung(inZahl);
  TempZahl := inZahl;
  //Die Basis_Nicht_Periode ermitteln
  TempBasPer := BasisPeriodeExtrahieren(TempZahl);
  TempPer := 0;
  IF TempZahl >1 then
    begin
    Faktorisierung(TempZahl);
    TempPhi := fEulerPhi;
    IF (TempPhi > 1) then
      begin
      Faktorisierung(TempPhi);
      i := 0;
      repeat
        TempPer := fTeiler[i];
        IF BasExpMod(fFakBasis,TempPer,TempZahl)= 1 then
          Break;
        inc(i);
      until i >= Length(fTeiler);
      IF i >= Length(fTeiler) then
        TempPer := inZahl-1;
      end;
    end;

  Faktorisierung(inZahl);
  fPeriodenlaenge := TempPer;
  fStartPeriode   := TempBasPer;
end;

procedure tFaktorisieren.NachkommaPeriode(var OutText: String);
var
  Rest,
  Rest1,
  Divi,
  base: Int64;
  i,
  limit : integer;

  pText : pChar;

  procedure Ziffernfolge(Ende: longint);
  //generate the digits in Base
  var
    j : longint;
  begin
    j := i-Ende;

    while j < 0 do
      begin
      Rest := Rest *base;
      Rest1:= Rest Div Divi;
      Rest := Rest-Rest1*Divi;//== Rest1 Mod Divi

      pText^ := chr(Rest1+Ord('0'));
      inc(pText);

      inc(j);
	  end;
	
	i := Ende;
  end;

begin
  limit:= fStartPeriode+fPeriodenlaenge;

  setlength(OutText,limit+2+2+5);
  OutText[1]:='0';
  OutText[2]:='.';
  pText := @OutText[3];

  Rest := fNominator;//1;
  Divi := fFakZahl;
  base := fFakBasis;

  i := 0;
  Ziffernfolge(fStartPeriode);
  if fPeriodenlaenge = 0 then
  begin
    setlength(OutText,fStartPeriode+2);
    EXIT;
  end;

  pText^ := '_'; inc(pText);
  Ziffernfolge(limit);
  pText^ := '_'; inc(pText);

  Ziffernfolge(limit+5);
end;

type
   tZahl   = integer;
   tRestFeld = array[0..31] of integer;

VAR
    F : tFaktorisieren;

function tFaktorisieren.BasExpMod( b, e, m : Dword) : DWord;
begin
  Result := 1;
  IF m = 0 then
    exit;
  Result := 1;
  while ( e > 0 ) do
    begin
    if (e AND 1) <> 0 then
      Result :=  (Result * int64(b)) mod m;
    b := (int64(b) * b ) mod m;
    e := e shr 1;
    end;
end;

procedure start;
VAR
  i,
  Divisor : DWord;
  Zeile : AnsiString;
  t1,t0: TDateTime;
BEGIN
  t0 := time;
  writeln('Calculate the length of period of 1/value');
  write('     value  start of   length of period     ');
  For i := low(cTestVal) to High(cTestVal) do
  begin
    writeln;
    Divisor := cTestVal[i];
    F.PeriodeErmitteln(Divisor);
	write(Divisor:10);
	if F.PeriodenLaenge > 0 then
      write(F.StartPeriode:10,F.PeriodenLaenge:12)
    else
      write(F.StartPeriode:10,'--':12);
    //only create small strings
    IF F.PeriodenLaenge < 1053 then
    begin
      F.NachkommaPeriode(Zeile);
      write('  ',Zeile);
    end;
    Zeile :='';
  end;
  t1 := time;
  writeln;
  writeln(FormatDateTime('HH:NN:SS.ZZZ',T1-T0),' time taken');
END;

BEGIN
  F := tFaktorisieren.create;
  start;
  writeln('Done');
  F.free;
  {$IFDEF WINDOWS}
  readln;
  {$ENDIF}
end.
