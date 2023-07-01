program Binary_strings;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

var
  x          : string;
  c          : TArray<Byte>;
  objecty,
  y          : string;
  empty      : string;
  nullString : string;
  whitespace,
  slice,
  greeting,
  join       : string;
begin
        //string creation
        x:= String.create(['1','2','3']);
        x:= String.create('*',8);
        x := 'hello world';

        //# string assignment with a hex byte
        x := 'ab'#10;
        writeln(x);
        writeln(x.Length); // 3

        //# string comparison
        if x = 'hello' then
            writeln('equal')
        else
            writeln('not equal');
        if x.CompareTo('bc') = -1 then
            writeln('x is lexicographically less than "bc"');

        //# string cloning
        y := x; // string is not object is delphi (are imutables)
        writeln(x = y);      //same as string.equals
        writeln(x.Equals(y)); //it overrides object.Equals

        //# check if empty
        // Strings can't be null (nil), just Pchar can be
        // IsNullOrEmpty and  IsNullOrWhiteSpace, check only for
        // Empty and Whitespace respectively.
        empty := '';
        whitespace := '   ';
        if (empty = string.Empty)  and
            string.IsNullOrEmpty(empty)  and
            string.IsNullOrWhiteSpace(empty)  and
            string.IsNullOrWhiteSpace(whitespace) then
            writeln('Strings are empty or whitespace');

        //# append a byte
        x := 'helloworld';
        x  := x + Chr(83);
//        x  := x + #83;    // the same of above line
        writeln(x);

        //# substring
        slice := x.Substring(5, 5);
        writeln(slice);

        //# replace bytes
        greeting := x.Replace('worldS', '');
        writeln(greeting);

        //# join strings
        join := greeting + ' ' + slice;
        writeln(join);

        Readln;
end.
