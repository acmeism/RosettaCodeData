with Ada.Text_IO, Ada.Strings.Fixed, Ada.Containers.Indefinite_Vectors;
use  Ada.Text_IO, Ada.Strings.Fixed, Ada.Containers;

procedure tokenize is
  package String_Vector is new Indefinite_Vectors (Natural,String); use String_Vector;
  procedure Parse (s : String; v : in out Vector) is
      i : Integer := Index (s,",");
  begin
    if s'Length > 0 then
      if i < s'First then
        v.Append (s);
      else
        v.Append (s (s'First..i-1));
        Parse ( s(i+1..s'Last), v);
      end if;
    end if;
  end Parse;
  v : Vector;
begin
  Parse ("Hello,How,Are,You,Today,,",v);
  for s of v loop
    put(s&".");
  end loop;
end tokenize;
