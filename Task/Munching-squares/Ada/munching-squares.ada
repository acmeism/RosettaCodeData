with Cairo; use Cairo;
with Cairo.Png; use Cairo.Png;
with Cairo.Image_Surface; use Cairo.Image_Surface;
procedure XorPattern is
   type xorable is mod 256;
   Surface : Cairo_Surface;
   Data : RGB24_Array_Access;
   Status : Cairo_Status;
   Num : Byte;
begin
   Data := new RGB24_Array(0..256*256-1);
   for x in Natural range 0..255 loop
      for y in Natural range 0..255 loop
         Num := Byte(xorable(x) xor xorable(y));
         Data(x+256*y) := RGB24_Data'(Num,0,Num);
      end loop;
   end loop;
   Surface := Create_For_Data_RGB24(Data, 256, 256);
   Status := Write_To_Png (Surface, "AdaXorPattern.png");
   pragma Assert (Status = Cairo_Status_Success);
end XorPattern;
