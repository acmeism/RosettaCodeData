with Ada.Text_IO;

procedure Cantor_Set is

   subtype Level_Range is Integer range 1 .. 5;
   Image : array (Level_Range) of String (1 .. 81) := (others => (others => ' '));

   procedure Cantor (Level : Natural; Length : Natural; Start : Natural) is
   begin
      if Level in Level_Range then
         Image (Level) (Start .. Start + Length - 1) := (others => '*');
         Cantor (Level + 1, Length / 3, Start);
         Cantor (Level + 1, Length / 3, Start + 2 * Length / 3);
      end if;
   end Cantor;
begin
   Cantor (Level  => Level_Range'First,
           Length => 81,
           Start  => 1);

   for L in Level_Range loop
      Ada.Text_IO.Put_Line (Image (L));
   end loop;
end Cantor_Set;
