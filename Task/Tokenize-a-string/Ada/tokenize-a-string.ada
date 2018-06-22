with Ada.Text_IO, Ada.Containers.Indefinite_Vectors;
use  Ada.Text_IO, Ada.Containers;

procedure tokenize is
  package String_Vector is new Indefinite_Vectors (Natural,String); use String_Vector;
  s       : String   := "Hello,How,Are,You,Today" & ",";
  current : Positive := s'First;
  v       : Vector;
begin
  for i in s'range loop
    if s (i) = ',' or i = s'last then
      v.append (s (current .. i-1));
      current := i + 1;
    end if;
   end loop;
  for s of v loop put(s & "."); end loop;
end tokenize;
