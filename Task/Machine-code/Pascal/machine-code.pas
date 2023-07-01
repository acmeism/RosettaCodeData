Program Example66;
{Inspired... program to demonstrate the MMap function. Freepascal docs }
Uses
  BaseUnix,Unix;

const
  code : array[0..9] of byte = ($8B, $44, $24, $4, $3, $44, $24, $8, $C3, $00);
  a :longInt= 12;
  b :longInt=  7;
type
  tDummyFunc = function(a,b:LongInt):LongInt;cdecl;
Var
    Len,k  : cint;
    P    : Pointer;

begin
  len := sizeof(code);
  P:= fpmmap(nil,
             len+1 ,
             PROT_READ OR PROT_WRITE OR PROT_EXEC,
             MAP_ANONYMOUS OR MAP_PRIVATE,
             -1, // for MAP_ANONYMOUS
             0);
  If P =  Pointer(-1) then
    Halt(4);

  for k := 0 to len-1 do
    pChar(p)[k] := char(code[k]);

  k := tDummyFunc(P)(a,b);

  Writeln(a,'+',b,' = ',k);
  if fpMUnMap(P,Len)<>0 Then
    Halt(fpgeterrno);
end.
