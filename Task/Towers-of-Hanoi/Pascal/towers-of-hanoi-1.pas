program Hanoi;
type
  TPole = (tpLeft, tpCenter, tpRight);
const
  strPole:array[TPole] of string[6]=('left','center','right');

 procedure MoveStack (const Ndisks : integer; const Origin,Destination,Auxiliary:TPole);
 begin
  if Ndisks >0 then begin
     MoveStack(Ndisks - 1, Origin,Auxiliary, Destination );
     Writeln('Move disk ',Ndisks ,' from ',strPole[Origin],' to ',strPole[Destination]);
     MoveStack(Ndisks - 1, Auxiliary, Destination, origin);
  end;
 end;

begin
 MoveStack(4,tpLeft,tpCenter,tpRight);
end.
