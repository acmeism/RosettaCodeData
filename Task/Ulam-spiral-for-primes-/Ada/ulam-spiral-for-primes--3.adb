with Generic_Ulam, Ada.Text_IO, Prime_Numbers;

procedure Ulam is

   package P is new Prime_Numbers(Natural, 0, 1, 2);

   function Vis(N: Natural) return String is
      (if P.Is_Prime(N) then " <>" else "   ");

   function Num(N: Natural) return String is
      (if P.Is_Prime(N) then
	(if N < 10 then "  " elsif N < 100 then " " else "") & Natural'Image(N)
      else " ---");

   procedure NL is
   begin
      Ada.Text_IO.New_Line;
   end NL;

   package Numeric is new Generic_Ulam(29, Num,  Ada.Text_IO.Put, NL);
   package Visual  is new Generic_Ulam(10, Vis,  Ada.Text_IO.Put, NL);

begin
   Numeric.Print_Spiral;
   NL;
   Visual.Print_Spiral;
end Ulam;
