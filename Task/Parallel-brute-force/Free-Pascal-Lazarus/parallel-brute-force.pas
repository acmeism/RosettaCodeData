program Brute_Force_SHA256;//Parallel_Brute_Force_SHA256;
{$mode Delphi}
//{$DEFINE UseCThreads}
uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}unix,cthreads,{$ENDIF}{$ENDIF}
  SysUtils,Classes,fpsha256;

var
  Words: array[1..3] of AnsiString =
   ('1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad',
    '3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b',
    '74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f');
  found: Integer;

procedure OutSol(const password,hash:AnsiString);
begin
  Writeln('>>', password, ' => ', hash);
end;

procedure Force(const password: AnsiString);inline;
var
  hash: AnsiString;
  SB : TBytes;
  i : Int32;
begin
  SB:=TEncoding.UTF8.GetAnsiBytes(password);
  TSHA256.DigestHexa(SB, hash);
  For i := found downto low(words) do
  begin
    if SameText(hash, words[i]) then
    begin
      OutSol(password, hash);
      //remove from search
      words[i] := words[found];
      dec(found);
      break;
    end;
  end;
end;

var
  password : AnsiString;
  a,b,c,d,e: byte;

begin
  Words[1] := uppercase(Words[1]);
  Words[2] := uppercase(Words[2]);
  Words[3] := uppercase(Words[3]);

  found := length(Words);
  password := 'aaaaa';
  for a := ord('a')to Ord('z') do
  begin
    password[1] := chr(a);
    for b := ord('a')to Ord('z') do
    begin
      password[2] := chr(b);
      for c := ord('a')to Ord('z') do
      begin
        password[3] := chr(c);
        for d := ord('a')to Ord('z') do
        begin
          password[4] := chr(d);
          for e := ord('a')to Ord('z') do
          begin
             password[5] := chr(e);
             force(password);
          end;
       end;
      end;
    end;
  end;
  Writeln('Enter to exit ',password);
  {$IFDEF WINDOWS}
  readln;
  {$ENDIF}
end.
