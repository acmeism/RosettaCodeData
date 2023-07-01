program Hanoi;
type
  TPole = (tpLeft, tpCenter, tpRight);
const
  strPole:array[TPole] of string[6]=('left','center','right');

 procedure MoveOneDisk(const DiskNum:integer; const Origin,Destination:TPole);
 begin
  Writeln('Move disk ',DiskNum,' from ',strPole[Origin],' to ',strPole[Destination]);
 end;

 procedure MoveStack (const Ndisks : integer; const Origin,Destination,Auxiliary:TPole);
 begin
  if Ndisks =1 then
       MoveOneDisk(1,origin,Destination)
  else begin
       MoveStack(Ndisks - 1, Origin,Auxiliary, Destination );
       MoveOneDisk(Ndisks,origin,Destination);
       MoveStack(Ndisks - 1, Auxiliary, Destination, origin);
  end;
 end;

begin
 MoveStack(4,tpLeft,tpCenter,tpRight);
end.
