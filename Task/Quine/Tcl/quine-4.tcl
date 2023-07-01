program quine;

const
     apos: Char = Chr(39);
     comma: Char = Chr(44);
     lines: Array[1..17] of String[80] = (
'program quine;',
'',
'const',
'     apos: Char = Chr(39);',
'     comma: Char = Chr(44);',
'     lines: Array[1..17] of String[80] = (',
'     );',
'',
'var',
'   num: Integer;',
'',
'begin',
'     for num := 1 to 6 do writeln(lines[num]);',
'     for num := 1 to 16 do writeln(apos, lines[num], apos, comma);',
'%     writeln(apos, lines[17], apos);',
'     for num := 7 to 17 do writeln(lines[num]);',
'end.'
     );

var
   num: Integer;

begin
     for num := 1 to 6 do writeln(lines[num]);
     for num := 1 to 16 do writeln(apos, lines[num], apos, comma);
     writeln(apos, lines[17], apos);
     for num := 7 to 17 do writeln(lines[num]);
end.
