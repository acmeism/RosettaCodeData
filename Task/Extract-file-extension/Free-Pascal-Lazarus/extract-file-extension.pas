Program Extract_file_extension;

{FreePascal has the built-in function ExtractFileExt which returns the file extension.
* it does need charachters before the period to return the proper extension and it returns
* the extension including the period}

Uses character,sysutils;

Const arr : array of string = ('http://example.com/download.tar.gz','CharacterModel.3DS','.desktop',
                               'document','document.txt_backup','/etc/pam.d/login');

Function extractextension(fn: String): string;
Var
  i: integer;
Begin
  fn := 'prefix' + fn; {add charachters before the period}
  fn := ExtractFileExt(fn);
  For i := 2 to length(fn) Do {skip the period}
    If Not IsLetterOrDigit(fn[i]) Then exit('');
 extractextension := fn;
End;

Var i : string;
Begin
  For i In arr Do
    writeln(i:35,' -> ',extractextension(i))
End.

