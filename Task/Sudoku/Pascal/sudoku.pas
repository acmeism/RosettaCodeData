Program soduko;
{$IFDEF FPC}
  {$CODEALIGN proc=16,loop=8}
{$ENDIF}
uses
  sysutils,crt;
const
  carreeSize = 3;
  maxCoor = carreeSize*carreeSize;
  maxValue = maxCoor;
  maxMask = 1 shl (maxCoor+1)-1;
type
  tLimit = 0..maxCoor-1;
  tValue = 0..maxCoor;
  tSteps = 0..maxCoor*maxCoor;
  tValField = array[tLimit,tLimit] of NativeInt;//tValue;
  tBitrepr = 0..maxMask;
  tcol = array[tLimit] of NativeInt;// tBitrepr;
  trow = array[tLimit] of NativeInt;// tBitrepr;
  tcar = array[tLimit] of NativeInt;// tBitrepr;
  tpValue = ^NativeInt;//^tValue;
  tpLimit = ^tLimit;
  tpBitrepr=  ^NativeInt;//^tBitrepr;
  tchgVal = record
              cvCol,
              cvRow,
              cvCar : tpBitrepr;
              cvVal : tpValue;
            end;
  tpChgVal = ^tchgVal;
  tchgList = array[tSteps] of tchgVal;

  tField = record
             fdChgList: tchgList;
             fdCol : tcol;
             fdRow : trow;
             fdcar : tcar;
             fdVal : tValField;
             fdChgIdx : tSteps;

           end;
const
  Expl0:tValField = ((9,0,7,0,0,0,3,0,0),
                     (0,0,0,1,0,0,2,0,0),
                     (6,0,0,0,0,8,0,0,0),
                     (0,0,5,0,3,0,0,0,0),
                     (0,0,0,0,0,0,0,8,4),
                     (0,0,0,0,0,0,0,6,0),
                     (0,0,0,2,7,0,0,0,0),
                     (8,4,0,0,0,0,0,0,0),
                     (0,6,0,0,0,0,0,0,0));
  Expl1:tValField=((0,0,0,1,0,0,0,3,8),
                   (2,0,0,0,0,5,0,0,0),
                   (0,0,0,0,0,0,0,0,0),
                   (0,5,0,0,0,0,4,0,0),
                   (4,0,0,0,3,0,0,0,0),
                   (0,0,0,7,0,0,0,0,6),
                   (0,0,1,0,0,0,0,5,0),
                   (0,0,0,0,6,0,2,0,0),
                   (0,6,0,0,0,4,0,0,0));

var
  F,
  solF : TField;
  solCnt,
  callCnt: NativeUint;
  solFound : Boolean;

procedure OutField(const F:tField);
var
  rw,cl : tLimit;
  rowS: AnsiString;
Begin
  GotoXy(1,1);
  For rw := low(tLimit) to High(tLimit) do
  Begin
    rowS := '  ';
    For cl := low(tLimit) to High(tLimit) do
      RowS :=RowS+IntToStr(F.fdVal[rw,cl]);
    writeln(RowS);
  end;
end;

function CarIdx(rw,cl: NativeInt):NativeInt;
begin
  CarIdx:= (rw DIV carreeSize)*carreeSize +cl DIV carreeSize;
end;
function InsertTest(const F:tField;rw,cl:tLimit;value:tValue):boolean;
var
  msk: tBitrepr;
Begin
  result := (Value = 0);
  IF result then
    EXIT;
  msk := 1 shl (value-1);
  with F do
  Begin
    result := fdRow[rw] AND msk = 0;
    result := result AND (fdCol[cl] AND msk = 0);
    rw :=CarIdx(rw,cl);
    result := result AND (fdCar[rw] AND msk = 0);
  end;
end;

function InitField(var F:tField;const InFd:tValField;DoReverse:boolean):boolean;
var
  TmpchgVal:tchgVal;
  rw,cl,
  value,
  msk    : NativeInt;
  leftSteps:tSteps;
Begin
  Fillchar(F,SizeOf(F),#0);
  leftSteps := High(tSteps)-1;
  //unknown fields inserted from end
  For rw := low(tLimit) to High(tLimit) do
    For cl := low(tLimit) to High(tLimit) do
    Begin
      value := InFd[rw,cl];
      IF InsertTest(F,rw,cl,value) then
      Begin
        with F do
        Begin
          if value > 0 then
          Begin
            msk := 1 shl (value-1);
            //given state
            //use pointer to the relevant places and mark as occupied
            with fdChgList[fdChgIdx] do
            begin
               cvCol := @fdCol[cl];
               cvCol^ +=Msk;
               cvRow := @fdRow[rw];
               cvRow^ +=Msk;
               cvCar := @fdCar[CarIdx(rw,cl)];
               cvCar^ +=Msk;
               cvVal := @fdVal[rw,cl];
               cvVal^ := value;
            end;
            inc(fdChgIdx);
          end
          else
          Begin
            //use pointer to the relevant places
            with fdChgList[leftSteps] do
            begin
               cvCol := @fdCol[cl];
               cvRow := @fdRow[rw];
               cvCar := @fdCar[CarIdx(rw,cl)];
               cvVal := @fdVal[rw,cl];
            end;
            dec(leftSteps);
          end;
        end
      end
      else
      Begin
        writeln(rw:10,cl:10,value:10);
        Writeln(' not solvable SuDoKu ');
        delay(2000);
        result := false;
        EXIT;
      end;
    end;
  //reverse direction of left over
  IF DoReverse then
  Begin
    leftSteps := High(tSteps)-1;
    rw := F.fdChgIdx;
    repeat
      TmpchgVal:= F.fdChgList[leftSteps];
      F.fdChgList[leftSteps]:= F.fdChgList[rw];
      F.fdChgList[rw] :=TmpchgVal;
      dec(leftSteps);
      inc(rw);
    until rw>=leftSteps;
  end;
  //OutField(F);
  solFound := false;
  result := true;
end;
procedure SolIsFound;
begin
  solF := F;
  inc(solCnt);
  solFound := True;
end;

procedure TryCell(var ChgVal:tpchgVal);
var
  value :NativeInt;
  poss,msk: NativeInt;
Begin
  IF solFound then EXIT;
  with ChgVal^ do
    poss:= (cvRow^ OR cvCol^ OR cvCar^) XOR maxMask;
  IF Poss = 0 then
    EXIT;

  value := 1;
  msk   := 1;

  repeat
    IF Poss AND MSK <>0 then
    Begin
      inc(callCnt);
      //insert test value
      with ChgVal^ do
      Begin
        cvCol^ := cvCol^ OR msk;
        cvRow^ := cvRow^ OR msk;
        cvCar^ := cvCar^ OR msk;
        cvVAl^ := value;
      end;
      //try next in list, if beyond last
      inc(ChgVal);

      IF ChgVal^.cvCol <> NIL then
        TryCell(ChgVal)
      else
        SolIsFound;
      //remove test value
      dec(ChgVal);
      with ChgVal^  do
      Begin
        cvCol^ := cvCol^ XOR msk;
        cvRow^ := cvRow^ XOR msk;
        cvCar^ := cvCar^ XOR msk;
        cvVAl^ := 0;
      end;
    end;
    inc(msk,msk);
    inc(value);
  until value> maxValue;
end;

var
  ChangeBegin : tpChgVal;
  k : NativeInt;
  T1,T0: TDateTime;
begin
  randomize;
  ClrScr;
  solCnt := 0;
  callCnt:= 0;
  T0 := time;
  k := 0;
  repeat
    InitField(F,Expl1,FALSE);
    ChangeBegin := @F.fdChgList[F.fdChgIdx];
    TryCell(ChangeBegin);
    inc(k);
  until k >= 5;
  T1 := time;
  Outfield(solF);
  writeln(86400*1000*(T1-T0)/k:10:3,' ms Test calls :',callCnt/k:8:0);
end.
