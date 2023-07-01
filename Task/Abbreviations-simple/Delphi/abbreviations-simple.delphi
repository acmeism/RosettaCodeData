program Abraviation_simple;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TCommand = record
    value: string;
    len: integer;
  end;

function ReadTable(table: string): TArray<TCommand>;
begin
  var fields := table.Split([' '], TStringSplitOptions.ExcludeEmpty);
  var i := 0;
  var max := Length(fields);
  while i < max do
  begin
    var cmd := fields[i];
    var cmdLen := cmd.Length;
    inc(i);

    if i < max then
    begin
      var num: Integer;
      if TryStrToInt(fields[i], num) and (1 <= num) and (num < cmdLen) then
      begin
        cmdLen := num;
        inc(i);
      end;
    end;

    SetLength(result, Length(result) + 1);
    with result[High(result)] do
    begin
      value := cmd;
      len := cmdLen;
    end;
  end;
end;

function ValidateCommands(Commands: TArray<TCommand>; Words: TArray<string>):
  TArray<string>;
begin
  SetLength(result, 0);
  for var wd in Words do
  begin
    var matchFound := false;
    var wLen := wd.Length;
    for var i := 0 to High(Commands) do
    begin
      var command := Commands[i];
      if (command.len = 0) or (wLen < command.len) or (wLen > command.value.Length) then
        Continue;
      var c := command.value.ToUpper;
      var w := wd.ToUpper;
      if c.StartsWith(w) then
      begin
        SetLength(result, Length(result) + 1);
        result[High(result)] := c;
        matchFound := true;
        Break;
      end;
    end;
    if not matchFound then
    begin
      SetLength(result, Length(result) + 1);
      result[High(result)] := '*error*';
    end;
  end;
end;

procedure PrintResults(words, results: TArray<string>);
begin
  Writeln('user words:');
  for var w in words do
    write(^I, w);
  Writeln(#10, 'full words:'^I, string.join(^I, results));
end;

const
  table = '' +
    'add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3 ' +
    'compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate ' +
    '3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2 ' +
    'forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load ' +
    'locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2 ' +
    'msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3 ' +
    'refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left ' +
    '2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1 ';

const
  SENTENCE = 'riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin';

begin
  var Commands := ReadTable(table);
  var Words := SENTENCE.Split([' '], TStringSplitOptions.ExcludeEmpty);

  var results := ValidateCommands(Commands, Words);

  PrintResults(Words, results);

  Readln;
end.
