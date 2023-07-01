package Generator is

   type Generator is tagged private;
   procedure Reset (Gen : in out Generator);
   function Get_Next (Gen : access Generator) return Natural;

   type Generator_Function is access function (X : Natural) return Natural;
   procedure Set_Generator_Function (Gen  : in out Generator;
                                     Func : Generator_Function);

   procedure Skip (Gen : access Generator'Class; Count : Positive := 1);

private

   function Identity (X : Natural) return Natural;

   type Generator is tagged record
      Last_Source : Natural := 0;
      Last_Value  : Natural := 0;
      Gen_Func    : Generator_Function := Identity'Access;
   end record;

end Generator;
