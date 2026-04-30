package My_Package is
   type My_Type is tagged private;
   procedure Some_Procedure(Item : out My_Type);
    function Set(Value : in Integer) return My_Type;
private
   type My_Type is tagged record
      Variable : Integer := -12;
   end record;
end My_Package;
