with Ada.Text_Io;
with Ada.Command_Line;
with Ada.Numerics.Elementary_Functions;

procedure Entropy is
   use Ada.Text_Io;

   type Hist_Type is array (Character) of Natural;

   function Log_2 (V : Float) return Float is
      use Ada.Numerics.Elementary_Functions;
   begin
      return Log (V) / Log (2.0);
   end Log_2;

   procedure Read_File (Name : String; Hist : out Hist_Type) is
      File : File_Type;
      Char : Character;
   begin
      Hist := (others => 0);
      Open (File, In_File, Name);
      while not End_Of_File (File) loop
         Get (File, Char);
         Hist (Char) := Hist (Char) + 1;
      end loop;
      Close (File);
   end Read_File;

   function Length_Of (Hist : Hist_Type) return Natural is
      Sum : Natural := 0;
   begin
      for V of Hist loop
         Sum := Sum + V;
      end loop;
      return Sum;
   end Length_Of;

   function Entropy_Of (Hist : Hist_Type) return Float is
      Length : constant Float := Float (Length_Of (Hist));
      Sum    : Float := 0.0;
   begin
      for V of Hist loop
         if V > 0 then
            Sum := Sum + Float (V) / Length * Log_2 (Float (V) / Length);
         end if;
      end loop;
      return -Sum;
   end Entropy_Of;

   package Float_Io is new Ada.Text_Io.Float_Io (Float);
   Name : constant String := Ada.Command_Line.Argument (1);
   Hist : Hist_Type;
   Entr : Float;
begin
   Float_Io.Default_Exp := 0;
   Float_Io.Default_Aft := 6;

   Read_File (Name, Hist);
   Entr := Entropy_Of (Hist);

   Put ("Entropy of '");
   Put (Name);
   Put ("' is ");
   Float_Io.Put (Entr);
   New_Line;
end Entropy;
