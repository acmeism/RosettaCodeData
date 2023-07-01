program seqNonSq;
 //sequence of non-squares
 //n = i + floor(1/2 + sqrt(i))
 function NonSquare(i: LongInt): LongInt;
 Begin
   NonSquare := i+trunc(sqrt(i) + 0.5);
 end;

 procedure First22;
 var
  i  : integer;
 begin
   For i := 1 to 21 do
     write(NonSquare(i):3,',');
   writeln(NonSquare(22):3);
 end;

 procedure OutSquare(i: integer);
 var
   n : LongInt;
 begin
   n := NonSquare(i);
   writeln('Square ',n,' found at ',i);
 end;

procedure Test(Limit: LongWord);
 var
  i ,n,sq,sn : LongWord;
 Begin
   sn := 1;
   sq := 1;
   For i := 1 to Limit do
   begin
     n := NonSquare(i);
     if n >= sq then
     begin
       if n > sq then
       begin
         sq := sq+2*sn+1; inc(sn);
       end
       else
         OutSquare(i);
     end;
   end;
 end;

 Begin
   First22;
   Test(1000*1000*1000);
 end.
