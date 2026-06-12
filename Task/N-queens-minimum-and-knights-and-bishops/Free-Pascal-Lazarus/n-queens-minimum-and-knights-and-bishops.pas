program TestMinimalQueen;
{$MODE DELPHI}{$OPTIMIZATION ON,ALL}

uses
  sysutils;
type
  tDeltaKoor = packed record
                        dRow,
                        dCol : Int8;
                      end;
const
  cKnightAttacks : array[0..7] of tDeltaKoor =
                   ((dRow:-2;dCol:-1),(dRow:-2;dCol:+1),
                    (dRow:-1;dCol:-2),(dRow:-1;dCol:+2),
                    (dRow:+1;dCol:-2),(dRow:+1;dCol:+2),
                    (dRow:+2;dCol:-1),(dRow:+2;dCol:+1));

  KoorCOUNT = 16;

type
  tLimit = 0..KoorCOUNT-1;

  tPlayGround = array[tLimit,tLimit] of byte;
  tCheckPG = array[0..2*KoorCOUNT] of tplayGround;
  tpPlayGround = ^tPlayGround;

var
{$ALIGN 32}
  CPG :tCheckPG;
  Qsol,BSol,KSol :tPlayGround;
  pgIdx,minIdx : nativeInt;

procedure pG_Out(pSol:tpPlayGround;ConvChar : string;lmt: NativeInt);
var
  row,col: NativeInt;
begin
  iF length(ConvChar)<>3 then
    EXIT;
  for row := lmt downto 0 do
  Begin
    for col := 0 to lmt do
      write(ConvChar[1+pSol^[row,col]],' ');
    writeln;
  end;
  writeln;
end;

procedure LeftAscDia(row,col,lmt: NativeInt);
var
  pPG :tpPlayGround;
  j: NativeInt;
begin
  pPG := @CPG[pgIdx];
  if row >= col then
  begin
    j := row-col;
    col := lmt-j;
    row := lmt;
    repeat
      pPG^[row,col] := 1;
      dec(col);
      dec(row);
    until col < 0;
  end
  else
  begin
    j := col-row;
    row := lmt-j;
    col := lmt;
    repeat
      pPG^[row,col] := 1;
      dec(row);
      dec(col);
   until row < 0;
  end;
end;

procedure RightAscDia(row,col,lmt: NativeInt);
var
  pPG :tpPlayGround;
  j: NativeInt;
begin
  pPG := @CPG[pgIdx];
  j := row+col;
  if j <= lmt then
  begin
    col := j;
    row := 0;
    repeat
      pPG^[row,col] := 1;
      dec(col);
      inc(row);
    until col < 0;
  end
  else
  begin
    col := lmt;
    row := j-lmt;
    repeat
      pPG^[row,col] := 1;
      inc(row);
      dec(col);
   until row > lmt;
  end;
end;

function check(lmt:nativeInt):boolean;
//check, if all fields are attacked
var
  pPG :tpPlayGround;
  pRow : pByte;
  row,col: NativeInt;
Begin
  pPG := @CPG[pgIdx];
  For row := lmt downto 0 do
  begin
    pRow := @pPG^[row,0];
    For col := lmt downto 0 do
      if pRow[col] = 0 then
        EXIT(false);
  end;
  exit(true);
end;

procedure SetQueen(row,lmt: NativeInt);
var
  pPG :tpPlayGround;
  i,col,t: NativeInt;
begin
  t := pgIdx+1;
  if t = minIDX then
    EXIT;
  pgIdx:= t;
  //use state before
//  CPG[pgIdx]:=CPG[pgIdx-1];
  move(CPG[t-1],CPG[t],SizeOf(tPlayGround));
  col := lmt;
  //first row only check one half -> symmetry
  if row = 0 then
    col := col shr 1;

  //check every column
  For col := col downto 0 do
  begin
    pPG := @CPG[pgIdx];
    if pPG^[row,col] <> 0 then
      continue;
    //set diagonals
    RightAscDia(row,col,lmt);
    LeftAscDia(row,col,lmt);
    //set row and column as attacked
    For i := 0 to lmt do
    Begin
      pPG^[row,i] := 1;
      pPG^[i,col] := 1;
    end;
    //now set position of queen
    pPG^[row,col] := 2;

    if check(lmt) then
    begin
      if minIdx> pgIdx then
      begin
        minIdx := pgIdx;
        Qsol := pPG^;
      end;
    end
    else
      if row > lmt then
        BREAK
      else
        //check next rows
        For t := row+1 to lmt do
          SetQueen(t,lmt);
    //copy last state
    t := pgIdx;
    move(CPG[t-1],CPG[t],SizeOf(tPlayGround));
//    CPG[pgIdx]:=CPG[pgIdx-1];
  end;
  dec(pgIdx);
end;

procedure SetBishop(row,lmt: NativeInt);
var
  pPG :tpPlayGround;
  col,t: NativeInt;
begin
  if pgIdx = minIDX then
    EXIT;
  inc(pgIdx);
  move(CPG[pgIdx-1],CPG[pgIdx],SizeOf(tPlayGround));
  col := lmt;
  if row = 0 then
    col := col shr 1;
  For col := col downto 0 do
  begin
    pPG := @CPG[pgIdx];
    if pPG^[row,col] <> 0 then
      continue;

    RightAscDia(row,col,lmt);
    LeftAscDia(row,col,lmt);

    //set position of bishop
    pPG^[row,col] := 2;

    if check(lmt) then
    begin
      if minIdx> pgIdx then
      begin
        minIdx := pgIdx;
        Bsol := pPG^;
      end;
    end
    else
      if row > lmt then
        BREAK
      else
      begin
        //check same row
        SetBishop(row,lmt);
        //check next row
        t := row+1;
        if (t <= lmt) then
          SetBishop(t,lmt);
      end;
    move(CPG[pgIdx-1],CPG[pgIdx],SizeOf(tPlayGround));
  end;
  dec(pgIdx);
end;

var
  lmt,max : NativeInt;

BEGIN
  max := 10;
  write(' nxn  n=:');
  For lmt := 1 to max do
    write(lmt:3);
  writeln;

  write(' Queens :');
  For lmt := 0 to max-1 do
  begin
    pgIdx := 0;
    minIdx := lmt;
    setQueen(0,lmt);
    write(minIDX:3);
  end;
  writeln;

  write(' Bishop :');
  For lmt := 0 to max-1 do
  begin
    pgIdx := 0;
    minIdx := 2*lmt+1;
    setBishop(0,lmt);
    write(minIDX:3);
  end;
  writeln;

  pG_Out(@Qsol,'_.Q',max-1);
  writeln;

  pG_Out(@Bsol,'_.B',max-1);
END.
