const
    SIZE = 256;
    NUM_PARTICLES = 1000;

procedure TForm1.Button1Click(Sender: TObject);
type
    TByteArray = array[0..0] of Byte;
    PByteArray = ^TByteArray;
var
    B: TBitmap;
    I: Integer;
    P, D: TPoint;
begin
    Randomize;
    B := TBitmap.Create;
    try
        B.Width := SIZE;
        B.Height := SIZE;
        B.PixelFormat := pf8bit;

        B.Canvas.Brush.Color := clBlack;
        B.Canvas.FillRect(B.Canvas.ClipRect);
        B.Canvas.Pixels[Random(SIZE), Random(SIZE)] := clWhite;

        For I := 0 to NUM_PARTICLES - 1 do
        Begin
            P.X := Random(SIZE);
            P.Y := Random(SIZE);

            While true do
            Begin
                D.X := Random(3) - 1;
                D.Y := Random(3) - 1;
                Inc(P.X, D.X);
                Inc(P.Y, D.Y);

                If ((P.X or P.Y) < 0) or (P.X >= SIZE) or (P.Y >= SIZE) Then
                Begin
                    P.X := Random(SIZE);
                    P.Y := Random(SIZE);
                end
                else if PByteArray(B.ScanLine[P.Y])^[P.X] <> 0 then
                begin
                    PByteArray(B.ScanLine[P.Y-D.Y])^[P.X-D.X] := $FF;
                    Break;
                end;
            end;
        end;

        Canvas.Draw(0, 0, B);
    finally
        FreeAndNil(B);
    end;
end;
