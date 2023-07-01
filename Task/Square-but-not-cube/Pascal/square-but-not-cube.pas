program SquareButNotCube;
var
  sqN,
  sqDelta,
  SqNum,

  cbN,
  cbDelta1,
  cbDelta2,
  CbNum,

  CountSqNotCb,
  CountSqAndCb : NativeUint;

begin
  CountSqNotCb := 0;
  CountSqAndCb := 0;
  SqNum := 0;
  CbNum := 0;
  cbN := 0;
  sqN := 0;
  sqDelta := 1;
  cbDelta1 := 0;
  cbDelta2 := 1;
  repeat
    inc(sqN);
    inc(sqNum,sqDelta);
    inc(sqDelta,2);
    IF sqNum>cbNum then
    Begin
      inc(cbN);
      cbNum := cbNum+cbDelta2;
      inc(cbDelta1,6);// 0,6,12,18...
      inc(cbDelta2,cbDelta1);//1,7,19,35...
    end;
    IF sqNum <> cbNUm then
    Begin
      writeln(sqNum :25);
      inc(CountSqNotCb);
    end
    else
    Begin
      writeln(sqNum:25,sqN:10,'*',sqN,' = ',cbN,'*',cbN,'*',cbN);
      inc(CountSqANDCb);
    end;
  until CountSqNotCb >= 30;//sqrt(High(NativeUint));
  writeln(CountSqANDCb,' where numbers are square and cube ');
end.
