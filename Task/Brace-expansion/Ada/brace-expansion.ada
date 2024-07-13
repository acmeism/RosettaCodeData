pragma Ada_2022;
with Ada.Containers;          use Ada.Containers;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded;   use Ada.Strings.Unbounded;
with Ada.Text_IO;             use Ada.Text_IO;
procedure Brace_Expansion is
   procedure Expand_Braces (Str : Unbounded_String) is
      package Position_Vectors is new Ada.Containers.Vectors (Natural, Natural);
      Escaped : Boolean := False;
      Depth   : Integer := 0;
      Brace_Points : Position_Vectors.Vector;
      Braces_To_Parse : Position_Vectors.Vector;
      Prefix, Suffix, Option  : Unbounded_String := Null_Unbounded_String;
   begin
      for Idx in 1 .. Length (Str) loop
         case Element (Str, Idx) is
            when '\' => Escaped := not Escaped;
            when '{' =>
               Depth := Depth + 1;
               if not Escaped and then Depth = 1 then
                  Brace_Points.Clear;
                  Brace_Points.Append (Idx);
               end if;
            when ',' =>
               if not Escaped and then Depth = 1 then
                  Brace_Points.Append (Idx);
               end if;
            when '}' =>
               if not Escaped and then Depth = 1 and then Brace_Points.Length > 1 then
                  Braces_To_Parse.Clear;
                  Braces_To_Parse.Append_Vector (Brace_Points);
                  Braces_To_Parse.Append (Idx);
               end if;
               Depth := Depth - 1;
            when others => null;
         end case;
         if Element (Str, Idx) /= '\' then
            Escaped := False;
         end if;
      end loop;
      if Braces_To_Parse.Length > 0 then
         Prefix := Unbounded_Slice (Str, 1, Braces_To_Parse (0) - 1);
         Suffix := Unbounded_Slice (Str, Braces_To_Parse.Last_Element + 1, Length (Str));
         for Idx in 1 .. Braces_To_Parse.Length - 1 loop
            Option := Unbounded_Slice (Str, Braces_To_Parse (Natural (Idx - 1)) + 1, Braces_To_Parse (Natural (Idx)) - 1);
            Expand_Braces (Prefix & Option & Suffix);
         end loop;
      else
         Put_Line (Str'Image);
      end if;
   end Expand_Braces;
   function "+"(S : String) return Unbounded_String renames To_Unbounded_String;
begin
   Expand_Braces (+"~/{Downloads,Pictures}/*.{jpg,gif,png}");
   Expand_Braces (+"It{{em,alic}iz,erat}e{d,}, please.");
   Expand_Braces (+"{,{,gotta have{ ,\, again\, }}more }cowbell!");
   Expand_Braces (+"{}} some }{,{\\{ edge, edge} \,}{ cases, {here} \\\\\}");
end Brace_Expansion;
