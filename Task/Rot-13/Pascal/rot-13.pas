program rot13;

var
    line: string;

    function rot13(someText: string): string;

    var
        i: integer;
        ch: char;
        result: string;

    begin
        result := '';
        for i := 1 to Length(someText) do
            begin
                ch := someText[i];
                case ch of
                    'A' .. 'M', 'a' .. 'm':
                        ch := chr(ord(ch)+13);
                    'N' .. 'Z', 'n' .. 'z':
                        ch := chr(ord(ch)-13);
                end;
                result := result + ch;
            end;
        rot13 := result;
    end;

begin
    while not eof(input) do
        begin
            readln(line);
            writeln(rot13(line));
        end;
end.
