type Kernel_3x3 is array (-1..1, -1..1) of Float_Luminance;

procedure Filter (Picture : in out Image; K : Kernel_3x3) is
   function Get (I, J : Integer) return Float_Pixel is
      pragma Inline (Get);
   begin
      if I in Picture'Range (1) and then J in Picture'Range (2) then
         declare
            Color : Pixel := Picture (I, J);
         begin
            return (Float_Luminance (Color.R), Float_Luminance (Color.G), Float_Luminance (Color.B));
         end;
      else
         return (others => 0.0);
      end if;
   end Get;
   W11, W12, W13 : Float_Pixel; -- The image window
   W21, W22, W23 : Float_Pixel;
   W31, W32, W33 : Float_Pixel;
   Above : array (Picture'First (2) - 1..Picture'Last (2) + 1) of Float_Pixel;
   This  : Float_Pixel;
begin
   for I in Picture'Range (1) loop
      W11 := Above (Picture'First (2) - 1); -- The upper row is taken from the cache
      W12 := Above (Picture'First (2)    );
      W13 := Above (Picture'First (2) + 1);
      W21 := (others => 0.0);               -- The middle row
      W22 := Get (I, Picture'First (2)    );
      W23 := Get (I, Picture'First (2) + 1);
      W31 := (others => 0.0);               -- The bottom row
      W32 := Get (I+1, Picture'First (2)    );
      W33 := Get (I+1, Picture'First (2) + 1);
      for J in Picture'Range (2) loop
         This :=
            W11 * K (-1, -1) + W12 * K (-1, 0) + W13 * K (-1, 1) +
            W21 * K ( 0, -1) + W22 * K ( 0, 0) + W23 * K ( 0, 1) +
            W31 * K ( 1, -1) + W32 * K ( 1, 0) + W33 * K ( 1, 1);
         Above (J-1) := W21;
         W11 := W12; W12 := W13; W13 := Above (J+1);     -- Shift the window
         W21 := W22; W22 := W23; W23 := Get (I,   J+1);
         W31 := W32; W32 := W23; W33 := Get (I+1, J+1);
         Picture (I, J) := To_Pixel (This);
      end loop;
      Above (Picture'Last (2)) := W21;
   end loop;
end Filter;
