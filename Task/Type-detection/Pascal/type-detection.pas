program typedetectiondemo (input, output);
type
   sourcetype = record case kind : (builtintext, filetext) of
                  builtintext : (i : integer);
                  filetext    : (f : file of char);
                end;

var
   source : sourcetype;
   input  : file of char;
   c      : char;

procedure printtext (source : sourcetype);
begin
   case source.kind of
     builtintext : case source.i of
                    1 : writeln ('This is text 1.');
                    2 : writeln ('This is text 2.')
                   end;
     filetext    : while not eof (source.f) do
                   begin
                      read (source.f, c);
                      write (c)
                   end
   end
end;

begin
   assign (input, 'type_detection-pascal.pas');
   reset (input);
   with source do
      begin
         kind := builtintext;
         i := 1;
         printtext (source);
         i := 2;
         printtext (source);
         kind := filetext;
         f := input;
         printtext (source)
      end
end.
