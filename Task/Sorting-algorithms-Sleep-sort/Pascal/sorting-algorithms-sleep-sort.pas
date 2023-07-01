program sleepsort;
{$IFDEF FPC}
  {$MODE DELPHI} {$Optimization ON,ALL}
{$ElSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  SysUtils;

const
  HiLimit = 40;
type
  tCombineForOneThread = record
    cft_count : Uint64;
    cft_ThreadID: NativeUint;
    cft_ThreadHandle: NativeUint;
  end;
  pThreadBlock = ^tCombineForOneThread;
var
  SortIdx : array of INteger;
  ThreadBlocks : array of tCombineForOneThread;
  gblThreadCount,
  Finished: Uint32;

  procedure PrepareThreads(thdCount:NativeInt);
  var
    i : NativeInt;
  Begin
    For i := 0 to thdCount-1 do
      ThreadBlocks[i].cft_count:= random(2*HiLimit);
  end;

  procedure TestRunThd(parameter: pointer);
  var
     pThdBlk: pThreadBlock;
     fi: NativeInt;
  begin
    pThdBlk := @ThreadBlocks[NativeUint(parameter)];
    with pThdBlk^ do
    begin
      sleep(40*cft_count+1);
      fi := Finished-1;
      //write(fi:5,cft_count:8,#13);
      InterLockedDecrement(Finished);
      SortIdx[fi]:= NativeUint(parameter);
    end;
    EndThread(0);
  end;

  procedure Test;
  var
    j,UsedThreads: NativeInt;
  begin
    randomize;
    UsedThreads:= GblThreadCount;
    Finished :=UsedThreads;
    PrepareThreads(UsedThreads);
    j := 0;
    while (j < UsedThreads) do
    begin
      with ThreadBlocks[j] do
        begin
          cft_ThreadHandle :=
          BeginThread(@TestRunThd, Pointer(j), cft_ThreadID,16384 {stacksize} );
          If cft_ThreadHandle = 0 then break;
        end;
      Inc(j);
    end;
    writeln(j);
    UsedThreads := j;
    Finished :=UsedThreads;
    repeat
      sleep(1);
    until finished = 0;
    For j := 0 to  UsedThreads-1 do
      CloseThread(ThreadBlocks[j].cft_ThreadID);

    //output of sleep-sorted data
    For j := UsedThreads-1 downto 1 do
      write(ThreadBlocks[SortIdx[j]].cft_count,',');
    writeln(ThreadBlocks[SortIdx[0]].cft_count);
  end;


begin
  randomize;
  gblThreadCount := Hilimit;
  Writeln('Testthreads : ',gblThreadCount);
  setlength(ThreadBlocks,gblThreadCount);
  setlength(SortIdx,gblThreadCount);
  Test;

  setlength(ThreadBlocks, 0);
  {$IFDEF WINDOWS}
  readln;
  {$ENDIF}
end.
