program square4;
{$MODE DELPHI}
{$R+,O+}
const
  LoDgt = 0;
  HiDgt = 9;
type
  tchkset = set of LoDgt..HiDgt;
  tSol = record
           solMin : integer;
           solDat : array[1..7] of integer;
         end;

var
  sum,a,b,c,d,e,f,g,cnt,uniqueCount : NativeInt;
  sol : array of tSol;

procedure SolOut;
var
  i,j,mn: NativeInt;
Begin
  mn := 0;
  repeat
    writeln(mn:3,' ...',mn+6:3);
    For i := Low(sol) to High(sol) do
      with sol[i] do
        IF solMin = mn then
        Begin
          For j := 1 to 7 do
            write(solDat[j]:3);
          writeln;
        end;
    writeln;
    inc(mn);
  until mn > HiDgt-6;
end;

function CheckUnique:Boolean;
var
  i,sum,mn: NativeInt;
  chkset : tchkset;

Begin
  chkset:= [];
  include(chkset,a);include(chkset,b);include(chkset,c);
  include(chkset,d);include(chkset,e);include(chkset,f);
  include(chkset,g);
  sum := 0;
  For i := LoDgt to HiDgt do
    IF i in chkset then
      inc(sum);

  result := sum = 7;
  IF result then
  begin
    inc(uniqueCount);
    //find the lowest entry
    mn:= LoDgt;
    For i := LoDgt to HiDgt do
      IF i in chkset then
      Begin
        mn := i;
        BREAK;
      end;
    // are they consecutive
    For i := mn+1 to mn+6  do
      IF NOT(i in chkset) then
        EXIT;

    setlength(sol,Length(sol)+1);
    with sol[high(sol)] do
      Begin
        solMin:= mn;
        solDat[1]:= a;solDat[2]:= b;solDat[3]:= c;
        solDat[4]:= d;solDat[5]:= e;solDat[6]:= f;
        solDat[7]:= g;
      end;
  end;
end;

Begin
  cnt := 0;
  uniqueCount := 0;
  For a:= LoDgt to HiDgt do
  Begin
    For b := LoDgt to HiDgt do
    Begin
      sum := a+b;
      //a+b = b+c+d => a = c+d => d := a-c
      For c := a-LoDgt downto LoDgt do
      begin
        d := a-c;
        e := sum-d;
        IF e>HiDgt then
          e:= HiDgt;
        For e := e downto LoDgt do
          begin
          f := sum-e-d;
          IF f in [loDGt..Hidgt]then
          Begin
            g := sum-f;
            IF g in [loDGt..Hidgt]then
            Begin
              inc(cnt);
              CheckUnique;
            end;
          end;
        end;
      end;
    end;
  end;
  SolOut;
  writeln('       solution count for ',loDgt,' to ',HiDgt,' = ',cnt);
  writeln('unique solution count for ',loDgt,' to ',HiDgt,' = ',uniqueCount);
end.
