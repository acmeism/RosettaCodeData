program Periode;

{$IFDEF FPC}
  {$MODE Delphi}
  {$OPTIMIZATION ON}
  {$OPTIMIZATION Regvar}
  {$OPTIMIZATION Peephole}
  {$OPTIMIZATION cse}
  {$OPTIMIZATION asmcse}
{$else}
  {$Apptype Console}
{$ENDIF}

uses
  sysutils;

const
  cBASIS = 10;
  PRIMFELDOBERGRENZE = 6542;
  {Das sind alle Primzahlen bis 2^16}
  {Das reicht fuer al8le Primzahlen bis 2^32}
  TESTZAHL = 500; //429496709;//High(Cardinal) DIV cBasis;

type
  tPrimFeld = array[1..PRIMFELDOBERGRENZE] of Word;

  tFaktorPotenz = record
    Faktor, Potenz: Cardinal;
  end;
   //2*3*5*7*11*13*17*19*23  *29 > Cardinal also maximal 9 Faktoren

  tFaktorFeld = array[1..9] of TFaktorPotenz; //Cardinal
// tFaktorFeld =  array [1..15] of TFaktorPotenz;//QWord

  tFaktorisieren = class(TObject)
  private
    fFakZahl: Cardinal;
    fFakBasis: Cardinal;
    fFakAnzahl: Cardinal;
    fAnzahlMoeglicherTeiler: Cardinal;
    fEulerPhi: Cardinal;
    fStartPeriode: Cardinal;
    fPeriodenLaenge: Cardinal;
    fTeiler: array of Cardinal;
    fFaktoren: tFaktorFeld;
    fBasFakt: tFaktorFeld;
    fPrimfeld: tPrimFeld;
    procedure PrimFeldAufbauen;
    procedure Fakteinfuegen(var Zahl: Cardinal; inFak: Cardinal);
    function BasisPeriodeExtrahieren(var inZahl: Cardinal): Cardinal;
    procedure NachkommaPeriode(var OutText: string);
  public
    constructor create; overload;
    function Prim(inZahl: Cardinal): Boolean;
    procedure AusgabeFaktorfeld(n: Cardinal);
    procedure Faktorisierung(inZahl: Cardinal);
    procedure TeilerErmitteln;
    procedure PeriodeErmitteln(inZahl: Cardinal);
    function BasExpMod(b, e, m: Cardinal): Cardinal;
    property EulerPhi: Cardinal read fEulerPhi;
    property PeriodenLaenge: Cardinal read fPeriodenLaenge;
    property StartPeriode: Cardinal read fStartPeriode;
  end;

constructor tFaktorisieren.create;
begin
  inherited;
  PrimFeldAufbauen;

  fFakZahl := 0;
  fFakBasis := cBASIS;
  Faktorisierung(fFakBasis);
  fBasFakt := fFaktoren;

  fFakZahl := 0;
  fEulerPhi := 1;
  fPeriodenLaenge := 0;
  fFakZahl := 0;
  fFakAnzahl := 0;
  fAnzahlMoeglicherTeiler := 0;
end;

function tFaktorisieren.Prim(inZahl: Cardinal): Boolean;
{Testet auf PrimZahl}
var
  Wurzel, pos: Cardinal;
begin
  if fFakZahl = inZahl then
  begin
    result := (fAnzahlMoeglicherTeiler = 2);
    exit;
  end;
  result := false;
  if inZahl > 1 then
  begin
    result := true;
    pos := 1;
    Wurzel := trunc(sqrt(inZahl));
    while fPrimFeld[pos] <= Wurzel do
    begin
      if (inZahl mod fPrimFeld[pos]) = 0 then
      begin
        result := false;
        break;
      end;
      inc(pos);
      if pos > High(fPrimFeld) then
        break;
    end;
  end;
end;

procedure tFaktorisieren.PrimFeldAufbauen;
{Baut die Liste der Primzahlen bis Obergrenze auf}
const
  MAX = 65536;
var
  TestaufPrim, Zaehler, delta: Cardinal;
begin
  Zaehler := 1;
  fPrimFeld[Zaehler] := 2;
  inc(Zaehler);
  fPrimFeld[Zaehler] := 3;

  delta := 2;
  TestaufPrim := 5;
  repeat
    if prim(TestaufPrim) then
    begin
      inc(Zaehler);
      fPrimFeld[Zaehler] := TestaufPrim;
    end;
    inc(TestaufPrim, delta);
    delta := 6 - delta; // 2,4,2,4,2,4,2,
  until (TestaufPrim >= MAX);

end; {PrimfeldAufbauen}

procedure tFaktorisieren.Fakteinfuegen(var Zahl: Cardinal; inFak: Cardinal);
var
  i: Cardinal;
begin
  inc(fFakAnzahl);
  with fFaktoren[fFakAnzahl] do
  begin
    fEulerPhi := fEulerPhi * (inFak - 1);
    Faktor := inFak;
    Potenz := 0;
    while (Zahl mod inFak) = 0 do
    begin
      Zahl := Zahl div inFak;
      inc(Potenz);
    end;
    for i := 2 to Potenz do
      fEulerPhi := fEulerPhi * inFak;
  end;
  fAnzahlMoeglicherTeiler := fAnzahlMoeglicherTeiler * (1 + fFaktoren[fFakAnzahl].Potenz);
end;

procedure tFaktorisieren.Faktorisierung(inZahl: Cardinal);
var
  j, og: longint;
begin
  if fFakZahl = inZahl then
    exit;

  fPeriodenLaenge := 0;
  fFakZahl := inZahl;
  fEulerPhi := 1;
  fFakAnzahl := 0;
  fAnzahlMoeglicherTeiler := 1;
  setlength(fTeiler, 0);

  if inZahl < 2 then
    exit;
  og := round(sqrt(inZahl) + 1.0);
{Suche Teiler von inZahl}
  for j := 1 to High(fPrimfeld) do
  begin
    if fPrimfeld[j] > og then
      Break;
    if (inZahl mod fPrimfeld[j]) = 0 then
      Fakteinfuegen(inZahl, fPrimfeld[j]);
  end;
  if inZahl > 1 then
    Fakteinfuegen(inZahl, inZahl);
  TeilerErmitteln;
end; {Faktorisierung}

procedure tFaktorisieren.AusgabeFaktorfeld(n: Cardinal);
var
  i: integer;
begin
  if fFakZahl <> n then
    Faktorisierung(n);
  write(fAnzahlMoeglicherTeiler: 5, ' Faktoren ');

  for i := 1 to fFakAnzahl - 1 do
    with fFaktoren[i] do
      if potenz > 1 then
        write(Faktor, '^', Potenz, '*')
      else
        write(Faktor, '*');
  with fFaktoren[fFakAnzahl] do
    if potenz > 1 then
      write(Faktor, '^', Potenz)
    else
      write(Faktor);

  writeln('  Euler Phi: ', fEulerPhi: 12, PeriodenLaenge: 12);
end;

procedure tFaktorisieren.TeilerErmitteln;
var
  Position: Cardinal;
  i, j: Cardinal;

  procedure FaktorAufbauen(Faktor: Cardinal; n: Cardinal);
  var
    i, Pot: Cardinal;
  begin
    Pot := 1;
    i := 0;
    repeat
      if n > Low(fFaktoren) then
        FaktorAufbauen(Pot * Faktor, n - 1)
      else
      begin
        FTeiler[Position] := Pot * Faktor;
        inc(Position);
      end;
      Pot := Pot * fFaktoren[n].Faktor;
      inc(i);
    until i > fFaktoren[n].Potenz;
  end;

begin
  Position := 0;
  setlength(FTeiler, fAnzahlMoeglicherTeiler);
  FaktorAufbauen(1, fFakAnzahl);
  //Sortieren
  for i := Low(fTeiler) to fAnzahlMoeglicherTeiler - 2 do
  begin
    j := i;
    while (j >= Low(fTeiler)) and (fTeiler[j] > fTeiler[j + 1]) do
    begin
      Position := fTeiler[j];
      fTeiler[j] := fTeiler[j + 1];
      fTeiler[j + 1] := Position;
      dec(j);
    end;
  end;
end;

function tFaktorisieren.BasisPeriodeExtrahieren(var inZahl: Cardinal): Cardinal;
var
  i, cnt, Teiler: Cardinal;
begin
  cnt := 0;
  result := 0;
  for i := Low(fBasFakt) to High(fBasFakt) do
  begin
    with fBasFakt[i] do
    begin
      if Faktor = 0 then
        BREAK;
      Teiler := Faktor;
      for cnt := 2 to Potenz do
        Teiler := Teiler * Faktor;
    end;
    cnt := 0;
    while (inZahl <> 0) and (inZahl mod Teiler = 0) do
    begin
      inZahl := inZahl div Teiler;
      inc(cnt);
    end;
    if cnt > result then
      result := cnt;
  end;
end;

procedure tFaktorisieren.PeriodeErmitteln(inZahl: Cardinal);
var
  i, TempZahl, TempPhi, TempPer, TempBasPer: Cardinal;
begin
  Faktorisierung(inZahl);
  TempZahl := inZahl;
  //Die Basis_Nicht_Periode ermitteln
  TempBasPer := BasisPeriodeExtrahieren(TempZahl);
  TempPer := 0;
  if TempZahl > 1 then
  begin
    Faktorisierung(TempZahl);
    TempPhi := fEulerPhi;
    if (TempPhi > 1) then
    begin
      Faktorisierung(TempPhi);
      i := 0;
      repeat
        TempPer := fTeiler[i];
        if BasExpMod(fFakBasis, TempPer, TempZahl) = 1 then
          Break;
        inc(i);
      until i >= Length(fTeiler);
      if i >= Length(fTeiler) then
        TempPer := inZahl - 1;
    end;
  end;

  Faktorisierung(inZahl);
  fPeriodenlaenge := TempPer;
  fStartPeriode := TempBasPer;
end;

procedure tFaktorisieren.NachkommaPeriode(var OutText: string);
var
  i, limit: integer;
  Rest, Rest1, Divi, basis: Cardinal;
  pText: pChar;

  procedure Ziffernfolge(Ende: longint);
  var
    j: longint;
  begin
    j := i - Ende;

    while j < 0 do
    begin
      Rest := Rest * basis;
      Rest1 := Rest div Divi;
      Rest := Rest - Rest1 * Divi; //== Rest1 Mod Divi

      pText^ := chr(Rest1 + Ord('0'));
      inc(pText);

      inc(j);
    end;

    i := Ende;
  end;

begin
  limit := fStartPeriode + fPeriodenlaenge;

  setlength(OutText, limit + 2 + 2 + 5);
  OutText[1] := '0';
  OutText[2] := '.';
  pText := @OutText[3];

  Rest := 1;
  Divi := fFakZahl;
  basis := fFakBasis;

  i := 0;
  Ziffernfolge(fStartPeriode);
  if fPeriodenlaenge = 0 then
  begin
    setlength(OutText, fStartPeriode + 2);
    EXIT;
  end;

  pText^ := '_';
  inc(pText);
  Ziffernfolge(limit);
  pText^ := '_';
  inc(pText);

  Ziffernfolge(limit + 5);
end;

type
  tZahl = integer;

  tRestFeld = array[0..31] of integer;

var
  F: tFaktorisieren;

function tFaktorisieren.BasExpMod(b, e, m: Cardinal): Cardinal;
begin
  Result := 1;
  if m = 0 then
    exit;
  Result := 1;
  while (e > 0) do
  begin
    if (e and 1) <> 0 then
      Result := (Result * int64(b)) mod m;
    b := (int64(b) * b) mod m;
    e := e shr 1;
  end;
end;

procedure start;
var
  Limit, Testzahl: Cardinal;
  longPrimCount: int64;
  t1, t0: TDateTime;
begin

  Limit := 500;
  Testzahl := 2;
  longPrimCount := 0;
  t0 := time;

  repeat
    write(Limit: 8, ': ');
    repeat
      if F.Prim(Testzahl) then
      begin
        F.PeriodeErmitteln(Testzahl);
        if F.PeriodenLaenge = Testzahl - 1 then
        begin
          inc(longPrimCount);
          if Limit = 500 then
            write(Testzahl, ',');
        end
      end;
      inc(Testzahl);
    until Testzahl = Limit;
    inc(Limit, Limit);
    write('  .. count ', longPrimCount: 8, ' ');
    t1 := time;
    if (t1 - t0) > 1 / 864000 then
      write(FormatDateTime('HH:NN:SS.ZZZ', t1 - t0));
    writeln;
  until Limit > 10 * 1000 * 1000;

  t1 := time;
  writeln;
  writeln('count of long primes ', longPrimCount);
  writeln('Benoetigte Zeit ', FormatDateTime('HH:NN:SS.ZZZ', t1 - t0));

end;

begin
  F := tFaktorisieren.create;
  writeln('Start');
  start;
  writeln('Fertig.');
  F.free;
  readln;
end.
