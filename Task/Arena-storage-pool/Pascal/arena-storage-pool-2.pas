Program Example16;
{ Program to demonstrate the Dispose and New functions. }
Type
  SS = String[20];
  AnObj = Object
    I : integer;
    Constructor Init;
    Destructor Done;
  end;

Var
  P : ^SS;
  T : ^AnObj;

Constructor Anobj.Init;
begin
  Writeln ( ' Initializing an instance of AnObj! ' );
end;

Destructor AnObj.Done;
begin
  Writeln ( ' Destroying an instance of AnObj! ' ) ;
end;

begin
  New ( P );
  P^ := 'Hello, World!';
  Dispose ( P );
{ P is undefined from here on! }
  New ( T, Init );
  T^.i := 0;
  Dispose ( T, Done );
end .
