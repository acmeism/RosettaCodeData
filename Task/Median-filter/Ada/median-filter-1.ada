function Median (Picture : Image; Radius : Positive) return Image is
   type Extended_Luminance is range 0..10_000_000;
   type VRGB is record
      Color : Pixel;
      Value : Luminance;
   end record;
   Width : constant Positive := 2*Radius*(Radius+1);
   type Window is array (-Width..Width) of VRGB;
   Sorted : Window;
   Next   : Integer;

   procedure Put (Color : Pixel) is -- Sort using binary search
      pragma Inline (Put);
      This   : constant Luminance :=
                  Luminance
                  (  (  2_126 * Extended_Luminance (Color.R)
                     +  7_152 * Extended_Luminance (Color.G)
                     +    722 * Extended_Luminance (Color.B)
                     )
                  /  10_000
                  );
      That   : Luminance;
      Low    : Integer := Window'First;
      High   : Integer := Next - 1;
      Middle : Integer := (Low + High) / 2;
   begin
      while Low <= High loop
         That   := Sorted (Middle).Value;
         if That > This then
            High := Middle - 1;
         elsif That < This then
            Low := Middle + 1;
         else
            exit;
         end if;
         Middle := (Low + High) / 2;
      end loop;
      Sorted (Middle + 1..Next) := Sorted (Middle..Next - 1);
      Sorted (Middle) := (Color, This);
      Next := Next + 1;
   end Put;
   Result : Image (Picture'Range (1), Picture'Range (2));
begin
   for I in Picture'Range (1) loop
      for J in Picture'Range (2) loop
         Next := Window'First;
         for X in I - Radius .. I + Radius loop
            for Y in J - Radius .. J + Radius loop
               Put
               (  Picture
                  (  Integer'Min (Picture'Last (1), Integer'Max (Picture'First (1), X)),
                     Integer'Min (Picture'Last (2), Integer'Max (Picture'First (2), Y))
               )  );
            end loop;
         end loop;
         Result (I, J) := Sorted (0).Color;
      end loop;
   end loop;
   return Result;
end Median;
