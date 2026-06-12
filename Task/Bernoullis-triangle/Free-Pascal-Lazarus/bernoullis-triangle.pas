program BernoulliTriangle;
const
  colSize = 6;
  rowSize = 15;
type
  tmyRow = array of Uint64;
  tpmyRow = pUint64;

  procedure RowOut(pRow0:tpmyRow;lmt,mid:int32);
  //format output to triangle
  begin
    mid := (colSize*mid) Div 2;
    write('':mid);
   for mid := 0 to lmt do
     write(pRow0[mid]:colSize);
   writeln;
  end;

var
  row : tmyRow;
  pRow : tpmyRow;
  prv1,prv2: Uint64;
  idx,col :NativeInt;
begin
  setlength(row,rowSize);
  //using pointer, because
  //dynamic arrays are slow (check always limits )
  pRow := @row[0];
  prv1 := 0;
  prv2 := 0;

  for col := 0 to rowSize-1 do
  begin
    for idx := 1 to col-1 do
    begin
      prv1 := prv2;
      prv2 := pRow[idx];
      pRow[idx] := prv1+prv2;
    end;
    pRow[col] := prv1+prv2+1;
    prv2 := pRow[0]; //first place always 1
    if rowSize < 16 then
      RowOut(pRow,col,rowSize-col);
  end;
  setlength(row,0);
end.
