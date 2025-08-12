program CistercianNumerals;

type
  TSignVals = -1 .. 1;

  TCanvas = object
  public
    procedure Init(GridSize: integer);
    procedure Clear;
    procedure DrawLine(R0, C0, Dist: integer; DR, DC: TSignVals);
    procedure Show;
    function Size: integer;
  private
    Cells: array of array of char;
    MaxCoord: integer;
  end;

  procedure TCanvas.Init(GridSize: integer);
  begin
    SetLength(Cells, GridSize, GridSize);
    MaxCoord := GridSize - 1;
  end;

  procedure TCanvas.Clear;
  var
    I, J: integer;
  begin
    for I := 0 to MaxCoord do
      for J := 0 to MaxCoord do
        Cells[I, J] := ' ';
  end;

  procedure TCanvas.DrawLine(R0, C0, Dist: integer; DR, DC: TSignVals);
  { Draws a straight (vertical, horizontal, or diagonal) line
    from Cells[R0, C0] to Cells[R0 + DR * Dist, C0 + DC * Dist]. }
  var
    C, R, I: integer;
  begin
    R := R0;
    C := C0;
    for I := 0 to Dist do
    begin
      Cells[R, C] := '*';
      R := R + DR;
      C := C + DC;
    end;
  end;

  procedure TCanvas.Show;
  var
    I, J: integer;
  begin
    for I := 0 to MaxCoord do
    begin
      for J := 0 to MaxCoord do
        Write(Cells[I, J]);
      WriteLn;
    end;
  end;

  function TCanvas.Size: integer;
  begin
    Result := MaxCoord + 1;
  end;

  procedure DrawNumber(var Canvas: TCanvas; V: integer);
  { DrawDigit is part of the algorithm, so it is nested in DrawNumber. }
  type
    TDigits = 0 .. 9;
  var
    Thousands, Hundreds, Tens, Ones: integer;
    RAxis, CAxis: integer;

    procedure DrawDigit(V: TDigits; RS, CS: TSignVals);
    { RS, CS are signs of rows and cols in in relation to the axis.
      They decide in which quadrant a digit is located. }
    begin
      case V of
        1: Canvas.DrawLine(RAxis + RS * 7, CAxis + CS, 4, 0, CS);
        2: Canvas.DrawLine(RAxis + RS * 3, CAxis + CS, 4, 0, CS);
        3: Canvas.DrawLine(RAxis + RS * 7, CAxis + CS,
            4, -RS, CS);
        4: Canvas.DrawLine(RAxis + RS * 3, CAxis + CS, 4, RS, CS);
        5:
        begin
          DrawDigit(1, RS, CS);
          DrawDigit(4, RS, CS);
        end;
        6: Canvas.DrawLine(RAxis + RS * 3, CAxis + CS * 5, 4, RS, 0);
        7:
        begin
          DrawDigit(1, RS, CS);
          DrawDigit(6, RS, CS);
        end;
        8:
        begin
          DrawDigit(2, RS, CS);
          DrawDigit(6, RS, CS);
        end;
        9:
        begin
          DrawDigit(1, RS, CS);
          DrawDigit(8, RS, CS);
        end
      end;
    end; {DrawDigit}

  begin {DrawNumber}
    RAxis := (Canvas.Size - 1) div 2;
    CAxis := 5;
    Canvas.DrawLine(0, CAxis, Canvas.Size - 1, 1, 0);
    {Draw 0 (or vertical axis)}
    Thousands := V div 1000;
    V := V mod 1000;
    Hundreds := V div 100;
    V := V mod 100;
    Tens := V div 10;
    Ones := V mod 10;
    if Thousands > 0 then
      DrawDigit(Thousands, 1, -1);
    if Hundreds > 0 then
      DrawDigit(Hundreds, 1, 1);
    if Tens > 0 then
      DrawDigit(Tens, -1, -1);
    if Ones > 0 then
      DrawDigit(Ones, -1, 1);
  end; {DrawNumber}

  procedure Test(N: integer);
  var
    Canvas: TCanvas;
  begin
    WriteLn(N, ':');
    Canvas.Init(15);
    Canvas.Clear;
    DrawNumber(Canvas, N);
    Canvas.Show;
    WriteLn;
  end;

begin
  Test(0);
  Test(1);
  Test(20);
  Test(300);
  Test(4000);
  Test(5555);
  Test(6789);
  Test(9999);
  // ReadLn;
end.
