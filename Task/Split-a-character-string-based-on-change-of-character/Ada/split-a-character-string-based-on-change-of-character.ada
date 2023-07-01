with Ada.Text_IO;
procedure Split is
  procedure Print_Tokens (s : String) is
    i, j : Integer := s'First;
  begin
    loop
      while j<=s'Last and then s(j)=s(i) loop j := j + 1; end loop;
      if i/=s'first then Ada.Text_IO.Put (", "); end if;
      Ada.Text_IO.Put (s(i..j-1));
      i := j;
      exit when j>s'last;
    end loop;
  end Print_Tokens;
begin
  Print_Tokens ("gHHH5YY+++");
end split;
