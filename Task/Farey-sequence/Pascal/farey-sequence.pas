program Farey;
 {$IFDEF FPC }{$MODE DELPHI}{$ELSE}{$APPTYPE CONSOLE}{$ENDIF}
uses
   sysutils;
type
   tNextFarey= record
                 nom,dom,n,c,d: longInt;
               end;

function  InitFarey(maxdom:longINt):tNextFarey;
Begin
  with result do
  Begin
    nom := 0; dom := 1; n   := maxdom;
    c   := 1; d   := maxdom;
  end;
end;

function NextFarey(var fn:tNextFarey):boolean;
var
  k,tmp: longInt;
Begin
  with fn do
  Begin
    k := trunc((n + dom)/d);
    tmp := c;c:= k*c-nom;nom:= tmp;
    tmp := d;d:= k*d-dom;dom:= tmp;
    result := nom <> dom;
  end;
end;

procedure CheckFareyCount( num: NativeUint);
var
  TestF : tNextFarey;
  cnt : NativeUint;
Begin
  TestF:= InitFarey(num);
  cnt := 1;
  repeat
    inc(cnt);
  until NOT(NextFarey(TestF));

  writeln('F(',TestF.n:4,')  = ',cnt:7);
end;

var
  TestF : tNextFarey;
  cnt: NativeInt;
Begin

  Writeln('Farey sequence for order 1 through 11 (inclusive): ');

  For cnt := 1 to 11 do
  Begin
      TestF:= InitFarey(cnt);
      write('F(',cnt:2,') =  ');
      repeat
         write(TestF.nom,'/',TestF.dom,',');
     until NOT(NextFarey(TestF));
     writeln(TestF.nom,'/',TestF.dom);
   end;
  writeln;
  writeln('Number of fractions in the Farey sequence:');
  cnt := 100;
  repeat
    CheckFareyCount(cnt);
    inc(cnt,100);
  until cnt > 1000;
end.
