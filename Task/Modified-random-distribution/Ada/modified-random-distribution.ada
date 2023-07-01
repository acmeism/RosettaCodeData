with Ada.Text_Io;
with Ada.Numerics.Float_Random;
with Ada.Strings.Fixed;

procedure Modified_Distribution is

   Observations : constant := 20_000;
   Buckets      : constant := 25;
   Divider      : constant := 12;
   Char         : constant Character := '*';

   generic
      with function Modifier (X : Float) return Float;
   package Generic_Random is
      function Random return Float;
   end Generic_Random;

   package body Generic_Random is
      package Float_Random renames Ada.Numerics.Float_Random;
      Generator : Float_Random.Generator;

      function Random return Float is
         Random_1 : Float;
         Random_2 : Float;
      begin
         loop
            Random_1 := Float_Random.Random (Generator);
            Random_2 := Float_Random.Random (Generator);
            if Random_2 < Modifier (Random_1) then
               return Random_1;
            end if;
         end loop;
      end Random;

   begin
     Float_Random.Reset (Generator);
   end Generic_Random;

   generic
      Buckets : in Positive;
   package Histograms is
      type Bucket_Index is new Positive range 1 .. Buckets;
      Bucket_Width : constant Float := 1.0 / Float (Buckets);
      procedure Clean;
      procedure Increment_Bucket (Observation : Float);
      function Observations_In (Bucket : Bucket_Index) return Natural;
      function To_Bucket (X : Float) return Bucket_Index;
      function Range_Image (Bucket : Bucket_Index) return String;
   end Histograms;

   package body Histograms is
      Hist : array (Bucket_Index) of Natural := (others => 0);

      procedure Clean is
      begin
         Hist := (others => 0);
      end Clean;

      procedure Increment_Bucket (Observation : Float) is
         Bin : constant Bucket_Index := To_Bucket (Observation);
      begin
         Hist (Bin) := Hist (Bin) + 1;
      end Increment_Bucket;

      function Observations_In (Bucket : Bucket_Index) return Natural
      is (Hist (Bucket));

      function To_Bucket (X : Float) return Bucket_Index
      is (1 + Bucket_Index'Base (Float'Floor (X / Bucket_Width)));

      function Range_Image (Bucket : Bucket_Index) return String is
         package Float_Io is new Ada.Text_Io.Float_Io (Float);
         Image : String := "F.FF..L.LL";
         First : constant Float := Float (Bucket - 1) / Float (Buckets);
         Last  : constant Float := Float (Bucket - 1 + 1) / Float (Buckets);
      begin
         Float_Io.Put (Image (1 .. 4),  First, Exp => 0, Aft => 2);
         Float_Io.Put (Image (7 .. 10), Last,  Exp => 0, Aft => 2);
         return Image;
      end Range_Image;

   begin
      Clean;
   end Histograms;

   function Modifier (X : Float) return Float
   is (if X in Float'First .. 0.5
       then 2.0 * (0.5 - X)
       else 2.0 * (X - 0.5));

   package Modified_Random is
     new Generic_Random (Modifier => Modifier);

   package Histogram_20 is
     new Histograms (Buckets => Buckets);

   function Column (Height : Natural; Char : Character) return String
     renames Ada.Strings.Fixed."*";

   use Ada.Text_Io;
begin
   for N in 1 .. Observations loop
      Histogram_20.Increment_Bucket (Modified_Random.Random);
   end loop;

   Put ("Range      Observations: "); Put (Observations'Image);
   Put ("  Buckets: "); Put (Buckets'Image);
   New_Line;
   for I in Histogram_20.Bucket_Index'Range loop
      Put (Histogram_20.Range_Image (I));
      Put (" ");
      Put (Column (Histogram_20.Observations_In (I) / Divider, Char));
      New_Line;
   end loop;
end Modified_Distribution;
