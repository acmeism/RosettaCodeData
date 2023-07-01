Program Rule30;
//http://en.wikipedia.org/wiki/Next_State_Rule_30;
//http://mathworld.wolfram.com/Rule30.html
{$IFDEF FPC}
  {$Mode Delphi}{$ASMMODE INTEL}
  {$OPTIMIZATION ON,ALL}
//  {$CODEALIGN proc=1}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  SysUtils;
const
  maxRounds = 2*1000*1000;
  rounds    = 10;

var
  Rule30_State : Uint64;

function GetCPU_Time: int64;
type
  TCpu = record
            HiCpu,
            LoCpu : Dword;
         end;
var
  Cput : TCpu;
begin
  asm
  RDTSC;
  MOV Dword Ptr [CpuT.LoCpu],EAX
  MOV Dword Ptr [CpuT.HiCpu],EDX
  end;
  with Cput do
    result := int64(HiCPU) shl 32 + LoCpu;
end;

procedure InitRule30_State;inline;
begin
  Rule30_State:= 1;
end;

procedure Next_State_Rule_30;inline;
var
  run, prev,next: Uint64;
begin
  run  := Rule30_State;
  Prev := RORQword(run,1);
  next := ROLQword(run,1);
  Rule30_State  := (next OR run) XOR prev;
end;

function NextRule30Byte:NativeInt;
//64-BIT can use many registers
//32-Bit still fast
var
  run, prev,next: Uint64;
  myOne : UInt64;
Begin
  run  := Rule30_State;
  result := 0;
  myOne  := 1;
  //Unrolling and inlining Next_State_Rule_30 by hand
  result := (result+result) OR (run AND myOne);
  next := ROLQword(run,1);
  Prev := RORQword(run,1);
  run  := (next OR run) XOR prev;

  result := (result+result) OR (run AND myOne);
  next := ROLQword(run,1);
  Prev := RORQword(run,1);
  run  := (next OR run) XOR prev;

  result := (result+result) OR (run AND myOne);
  next := ROLQword(run,1);
  Prev := RORQword(run,1);
  run  := (next OR run) XOR prev;

  result := (result+result) OR (run AND myOne);
  next := ROLQword(run,1);
  Prev := RORQword(run,1);
  run  := (next OR run) XOR prev;

  result := (result+result) OR (run AND myOne);
  next := ROLQword(run,1);
  Prev := RORQword(run,1);
  run  := (next OR run) XOR prev;

  result := (result+result) OR (run AND myOne);
  next := ROLQword(run,1);
  Prev := RORQword(run,1);
  run  := (next OR run) XOR prev;

  result := (result+result) OR (run AND myOne);
  next := ROLQword(run,1);
  Prev := RORQword(run,1);
  run  := (next OR run) XOR prev;

  result := (result+result) OR (run AND myOne);
  next := ROLQword(run,1);
  Prev := RORQword(run,1);
  Rule30_State := (next OR run) XOR prev;
end;

procedure Speedtest;
var
  T1,T0 : INt64;
  i: NativeInt;
Begin
  writeln('Speedtest for statesize of ',64,' bits');
  //Warm up start to wake up CPU takes some time
  For i := 100*1000*1000-1 downto 0 do
    Next_State_Rule_30;

  T0 := GetCPU_Time;
  InitRule30_State;
  For  i := maxRounds-1 downto 0 do
    NextRule30Byte;
  T1 := GetCPU_Time;
  writeln(NextRule30Byte);
  writeln('cycles per Byte : ',(T1-t0)/maxRounds:0:2);
  writeln;
end;

procedure Task;
var
  i: integer;
Begin
  writeln('The task ');
  InitRule30_State;
  For  i := 1 to rounds do
    write(NextRule30Byte:4);
  writeln;
end;

Begin
  SpeedTest;
  Task;
  write(' <ENTER> ');readln;
end.
