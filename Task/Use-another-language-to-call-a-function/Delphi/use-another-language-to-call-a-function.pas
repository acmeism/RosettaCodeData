function Query(Buffer: PChar; var Size: Int64): LongBool;
const
    Text = 'Hello World!';
begin
    If not Assigned(Buffer) Then
    begin
        Size := 0;
        Result := False;
        Exit;
    end;
    If Size < Length(Text) Then
    begin
        Size := 0;
        Result := False;
        Exit;
    end;

    Size := Length(Text);
    Move(Text[1], Buffer^, Size);
    Result := True;
end;
