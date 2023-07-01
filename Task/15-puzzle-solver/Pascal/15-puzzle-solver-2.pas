// Threaded use of 15 solver Unit. Nigel Galloway; February 1st., 2019.
program testFifteenSolver;
uses {$IFDEF UNIX}cthreads,{$ENDIF}sysutils,strutils,FifteenSolverT;
var Tz:array[0..5] of TThreadID; Tr:array[0..5] of TG; Tc:array[0..5] of shortint; Tw:array[0..5] of shortint;
const N:array[0..4 ] of string=('','d','u','r','l');
const G:array[0..15] of string=('41','841','841','81','421','8421','8421','821','421','8421','8421','821','42','842','842','82');
var ip:string; x,y:UInt64; P,Q:^TN; bPos,v,w,z,f:shortint; time1, time2: TDateTime; c:char;
function T(a:pointer):ptrint;
begin
  Tr[uint32(a)]:=solve15(x,bPos,Tw[uint32(a)],Tc[uint32(a)]);
  if Tr[uint32(a)].found then f:=uint32(a);
  T:=0;
end;
begin
  ReadLn(ip);
  bPos:=Npos('0',ip,1)-1; w:=0; z:=0; f:=-1;
  y:=(UInt64(Hex2Dec(ip[9..17]))<<32)>>32; x:=UInt64(Hex2Dec(ip[1..8]))<<32+y;
  time1:=Now;
  for w:=0 to $7f do begin
    for c in G[bpos] do begin v:=z mod 6; Tc[v]:=integer(c)-48; Tw[v]:=w;
      Tz[v]:=BeginThread(@T,pointer(v));
      z+=1; if z>5 then waitforthreadterminate(Tz[z mod 6],$7fff);
    end;
    if f>=0 then break;
  end;
  for bpos:=0 to 5 do if Tw[bpos]>=Tw[f] then killthread(Tz[bpos]) else waitforthreadterminate(Tz[bpos],$7fff);
  time2:=Now; WriteLn('Solution(s) found in ' +  FormatDateTime('hh.mm.ss.zzz', time2-time1) + ' seconds');
  for bpos:=0 to 5 do if Tr[bpos].found then begin
    P:=@Tr[bpos].path; repeat Q:=P; Write(N[Q^.g]); P+=1; until Q^.n=endpos; WriteLn();
  end;
end.
