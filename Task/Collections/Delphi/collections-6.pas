var
    Str1:String;  // default WideString
    Str2:WideString;
    Str3:UnicodeString;
    Str4:AnsiString;
    Str5: PChar; //PWideChar is the same
    Str6: PAnsiChar;

    // Strings can be initialized, if it's global variable in declaration scope
    Str4: string = 'orange';
begin
    Str1 := 'apple';

    // WideString and AnsiString can be converted implicitly, but in some times can lost information about char
    Str4 := Str1;

    // PChar is a poiter to string (WideString), must be converted using type cast
    Str5 := Pchar(Str1);

    // PChar not must type cast to convert back string
    Str2 := Str5;

    //In any string, index start in 1 and end on length of string
    Writeln(Str1[1]); // 'a'
    Writeln(Str1[5]); // 'e'
    Writeln(Str1[length(str1)]); // the same above
end;
