program DutchF;

  { Dutch national flag problem }

type
  TColor = (Blue, White, Red);

const
  N = 20;

var
  T: array [0 .. N - 1] of TColor;
  I: cardinal;

  procedure Swap(var A, B: TColor);
  var
    Tmp: TColor;
  begin
    Tmp := A;
    A := B;
    B := Tmp;
  end;

  procedure WriteColorSeq(T: array of TColor);
  var
    I: cardinal;
  begin
    for I := low(T) to high(T) do
      case T[I] of
        Blue: Write('B');
        White: Write('W');
        Red: Write('R');
      end;
    WriteLn;
  end;

  procedure SortByColor(var T: array of TColor);
  var
    B, W, R: cardinal;
  begin
    B := Low(T);
    W := Low(T);
    R := High(T);
    while W <= R do
      case T[W] of
        White:
          Inc(W);
        Blue:
        begin
          Swap(T[B], T[W]);
          Inc(B);
          Inc(W);
        end;
        Red:
        begin
          Swap(T[W], T[R]);
          Dec(R);
        end;
      end;
  end;

begin
  { Set colors }
  Randomize;
  for I := 0 to N - 1 do
    T[I] := TColor(Random(3));
  writeln('Unsorted:');
  WriteColorSeq(T);
  SortByColor(T);
  WriteLn;
  writeln('Sorted:');
  WriteColorSeq(T);
  {readln;}
end.
