with Spark_IO;
--# inherit Spark_IO;
--# main_program;
procedure Dot_Product_Main
--# global in out Spark_IO.Outputs;
--# derives Spark_IO.Outputs from *;
is
   Limit : constant := 1000;
   type V_Elem is range -Limit .. Limit;
   V_Size : constant := 100;
   type V_Index is range 1 .. V_Size;
   type Vector is array(V_Index range <>) of V_Elem;

   type V_Prod is range -(Limit**2)*V_Size .. (Limit**2)*V_Size;
   --# assert V_Prod'Base is Integer;

   subtype Index3 is V_Index range 1 .. 3;
   subtype Vector3 is Vector(Index3);
   Vect1 : constant Vector3 := Vector3'(1, 3, -5);
   Vect2 : constant Vector3 := Vector3'(4, -2, -1);

   function Dot_Product(V1, V2 : Vector) return V_Prod
   --# pre  V1'First = V2'First
   --#  and V1'Last  = V2'Last;
   is
      Sum : V_Prod := 0;
   begin
      for I in V_Index range V1'Range
      --# assert Sum in -(Limit**2)*V_Prod(I-1) .. (Limit**2)*V_Prod(I-1);
      loop
         Sum := Sum + V_Prod(V1(I)) * V_Prod(V2(I));
      end loop;
      return Sum;
   end Dot_Product;

begin
   Spark_IO.Put_Integer(File  => Spark_IO.Standard_Output,
                        Item  => Integer(Dot_Product(Vect1, Vect2)),
                        Width => 6,
                        Base  => 10);
end Dot_Product_Main;
