{$zerobasedstrings on}

begin
  var commandData :=
    '''
    add 1 alter 3 backup 2 bottom 1 Cappend 2 change 1 Schange Cinsert 2 Clast 3
    compress 4 copy 2 count 3 Coverlay 3 cursor 3 delete 3 Cdelete 2 down 1 duplicate
    3 xEdit 1 expand 3 extract 3 find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2
    forward 2 get help 1 hexType 4 input 1 powerInput 3 join 1 split 2 spltJOIN load
    locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2 macro merge 2 modify 3 move 2
    msg next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit read recover 3
    refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left
    2 save set shift 2 si sort sos stack 3 status 4 top transfer 3 type 1 up 1
    '''.ToWords(AllDelimiters);

  var abbrDict := Dict('' to '');

  var i := 0;
  while i < commandData.Length do
  begin
    var cmd := commandData[i];
    i += 1;

    // Если следующего элемента нет или он не число, используем длину команды
    var minLen := cmd.Length;
    if (i < commandData.Length) and commandData[i].All(char.IsDigit) then
    begin
      minLen := commandData[i].ToInteger;
      i += 1;
    end;

    var cmdLower := cmd.ToLower;
    for var len := minLen to cmd.Length do
    begin
      var abbr := cmdLower[:len];
      abbrDict[abbr] := cmd.ToUpper;
    end;
  end;

  var testStr := 'riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin';
  Writeln(' Input: ', testStr);
  Writeln('Output: ', testStr.ToWords()
    .Select(w -> abbrDict.Get(w.Trim.ToLower,'*error*'))
    .JoinToString);

  testStr := '';
  Writeln(' Input: ', testStr);
  Writeln('Output: ', testStr.ToWords()
    .Select(w -> abbrDict.Get(w.Trim.ToLower,'*error*'))
    .JoinToString);
end.
