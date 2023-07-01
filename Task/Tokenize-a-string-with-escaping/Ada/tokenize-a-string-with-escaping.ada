with Ada.Text_Io;
with Ada.Containers.Indefinite_Vectors;
with Ada.Strings.Unbounded;

procedure Tokenize is

   package String_Vectors is
     new Ada.Containers.Indefinite_Vectors (Positive, String);
   use String_Vectors;

   function Split (Text      : String;
                   Separator : Character := '|';
                   Escape    : Character := '^') return Vector
   is
      use Ada.Strings.Unbounded;
      Result  : Vector;
      Escaped : Boolean := False;
      Accu    : Unbounded_String;
   begin

      for Char of Text loop

         case Escaped is

            when False =>
               if Char = Escape then
                  Escaped := True;
               elsif Char = Separator then
                  Append (Result, To_String (Accu));
                  Accu := Null_Unbounded_String;
               else
                  Append (Accu, Char);
               end if;

            when True =>
               Append (Accu, Char);
               Escaped := False;

         end case;

      end loop;
      Append (Result, To_String (Accu));

      return Result;
   end Split;

   procedure Put_Vector (List : Vector) is
      use Ada.Text_Io;
   begin
      for Element of List loop
         Put ("'"); Put (Element); Put ("'"); New_Line;
      end loop;
   end Put_Vector;

begin
   Put_Vector (Split ("one^|uno||three^^^^|four^^^|^cuatro|"));
end Tokenize;
