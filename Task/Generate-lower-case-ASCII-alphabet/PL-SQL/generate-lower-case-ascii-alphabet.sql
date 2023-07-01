Declare
 sbAlphabet  varchar2(100);
Begin
  For nuI in 97..122 loop
      if sbAlphabet is null then
         sbAlphabet:=chr(nuI);
      Else
         sbAlphabet:=sbAlphabet||','||chr(nuI);
      End if;
  End loop;
  Dbms_Output.Put_Line(sbAlphabet);
End;
