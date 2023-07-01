with Ada.Text_IO;
with GNAT.SHA1;

procedure Main is
begin
   Ada.Text_IO.Put_Line ("SHA1 (""Rosetta Code"") = " &
                         GNAT.SHA1.Digest ("Rosetta Code"));
end Main;
