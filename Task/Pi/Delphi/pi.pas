unit Pi_BBC_Main;

interface

uses
  Classes, Controls, Forms, Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    btnRunSpigotAlgo: TButton;
    memScreen: TMemo;
    procedure btnRunSpigotAlgoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fScreenWidth : integer;
    fLineBuffer : string;
    procedure ClearText();
    procedure AddText( const s : string);
    procedure FlushText();
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses SysUtils;

// Button clicked to run algorithm
procedure TForm1.btnRunSpigotAlgoClick(Sender: TObject);
var
  // BBC Basic variables. Delphi longint is 32 bits.
  B : array of longint;
  A, C, D, E, I, L, M, P : longint;
  // Added for Delphi version
  temp : string;
  h, j, t : integer;
begin
  fScreenWidth := 80;
  ClearText();
  M := 5368709; // floor( (2^31 - 1)/400 )

  // DIM B%(M%) in BBC Basic declares an array [0..M%], i.e. M% + 1 elements
  SetLength( B, M + 1);
  for I := 0 to M do B[I] := 20;
  E := 0;
  L := 2;

  // FOR C% = M% TO 14 STEP -7
  // In Delphi (or at least Delphi 7) the step size in a for loop has to be 1.
  // So the BBC Basic FOR loop has been replaced by a repeat loop.
  C := M;
  repeat
    D := 0;
    A := C*2 - 1;
    for P := C downto 1 do begin
      D := D*P + B[P]*$64; // hex notation copied from BBC version
      B[P] := D mod A;
      D := D div A;
      dec( A, 2);
    end;

    // The BBC CASE statement here amounts to a series of if ... else
    if (D = 99) then begin
      E := E*100 + D;
      inc( L, 2);
    end
    else if (C = M) then begin
      AddText( SysUtils.Format( '%2.1f', [1.0*(D div 100) / 10.0] ));
      E := D mod 100;
    end
    else begin
      // PRINT RIGHT$(STRING$(L%,"0") + STR$(E% + D% DIV 100),L%);
      // This can't be done so concisely in Delphi 7
      SetLength( temp, L);
      for j := 1 to L do temp[j] := '0';
      temp := temp + SysUtils.IntToStr( E + D div 100);
      t := Length( temp);
      AddText( Copy( temp, t - L + 1, L));
      E := D mod 100;
      L := 2;
    end;
    dec( C, 7);
  until (C < 14);
  FlushText();

  // Delphi addition: Write screen output to a file for checking
  h := SysUtils.FileCreate( 'C:\Delphi\PiDigits.txt'); // h = file handle
  for j := 0 to memScreen.Lines.Count - 1 do
    SysUtils.FileWrite( h, memScreen.Lines[j][1], Length( memScreen.Lines[j]));
  SysUtils.FileClose( h);
end;

{=========================== Auxiliary routines ===========================}

// Form created
procedure TForm1.FormCreate(Sender: TObject);
begin
  fScreenWidth := 80; // in case not set by the algotithm
  ClearText();
end;

// This Delphi version builds each screen line in a buffer and puts
//   the line into the TMemo when the buffer is full.
// This is faster than writing to the TMemo a few characters at a time,
//   but note that the buffer must be flushed at the end of the program.
procedure TForm1.ClearText();
begin
  memScreen.Lines.Clear();
  fLineBuffer := '';
end;

procedure TForm1.AddText( const s : string);
var
  nrChars, nrLeft : integer;
begin
  nrChars := Length( s);
  nrLeft := fScreenWidth - Length( fLineBuffer); // nr chars left in line
  if (nrChars <= nrLeft) then fLineBuffer := fLineBuffer + s
  else begin
    fLineBuffer := fLineBuffer + Copy( s, 1, nrLeft);
    memScreen.Lines.Add( fLineBuffer);
    fLineBuffer := Copy( s, nrLeft + 1, nrChars - nrLeft);
  end;
end;

procedure TForm1.FlushText();
begin
  if (Length(fLineBuffer) > 0) then begin
    memScreen.Lines.Add( fLineBuffer);
    fLineBuffer := '';
  end;
end;

end.
