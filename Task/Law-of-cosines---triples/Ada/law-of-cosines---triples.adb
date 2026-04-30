with Ada.Text_IO;
with Ada.Containers.Ordered_Maps;

procedure Law_Of_Cosines is

   type Angle_Kind is (Angle_60, Angle_90, Angle_120);

   function Is_Triangle (A, B, C : in Positive;
                         Angle   : in Angle_Kind) return Boolean
   is
      A2 : constant Positive := A**2;
      B2 : constant Positive := B**2;
      C2 : constant Positive := C**2;
      AB : constant Positive := A * B;
   begin
      case Angle is
         when Angle_60  =>  return A2 + B2 - AB = C2;
         when Angle_90  =>  return A2 + B2 = C2;
         when Angle_120 =>  return A2 + B2 + AB = C2;
      end case;
   end Is_Triangle;

   procedure Count_Triangles is
      use Ada.Text_IO;
      Count : Natural;
   begin
      for Angle in Angle_Kind loop
         Count := 0;
         Put_Line (Angle'Image & " triangles");
         for A in 1 ..13 loop
            for B in 1 .. A loop
               for C in 1 .. 13 loop
                  if Is_Triangle (A, B, C, Angle) then
                     Put_Line (A'Image & B'Image & C'Image);
                     Count := Count + 1;
                  end if;
               end loop;
            end loop;
         end loop;
         Put_Line ("There are " & Count'Image & " " & Angle'Image &" triangles");
      end loop;
   end Count_Triangles;

   procedure Extra_Credit (Limit : in Natural) is
      use Ada.Text_IO;

      package Square_Maps is new Ada.Containers.Ordered_Maps (Natural, Boolean);
      Squares : Square_Maps.Map;

      Count : Natural :=  0;
   begin
      for C in 1 .. Limit loop
         Squares.Insert (C**2, True);
      end loop;

      for A in 1 .. Limit loop
         for B in 1 .. A loop
            if Squares.Contains (A**2 + B**2 - A * B) then
               Count := Count + 1;
            end if;
         end loop;
      end loop;
      Put_Line ("There are " & Natural'(Count - Limit)'Image &
                  " " & Angle_60'Image &" triangles between 1 and " & Limit'Image & ".");
   end Extra_Credit;

begin
   Count_Triangles;
   Extra_Credit (Limit => 10_000);
end Law_Of_Cosines;
