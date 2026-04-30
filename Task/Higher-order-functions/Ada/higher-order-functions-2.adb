with Ada.Text_Io; use Ada.Text_Io;

procedure Subprogram_As_Argument_2 is

   -- Definition of an access to long_float

   type Lf_Access is access Long_Float;

   -- Definition of a function returning Lf_Access taking an
   -- integer as a parameter

   function Func_To_Be_Passed(Item : Integer) return Lf_Access is
      Result : Lf_Access := new Long_Float;
   begin
      Result.All := 3.14159 * Long_Float(Item);
      return Result;
   end Func_To_Be_Passed;

   -- Definition of an access to function type matching the function
   -- signature above

   type Func_Access is access function(Item : Integer) return Lf_Access;

   -- Definition of an integer access type

   type Int_Access is access Integer;

   -- Define a function taking an instance of Func_Access as its
   -- parameter and returning an integer access type

   function Complex_Func(Item : Func_Access; Parm2 : Integer) return Int_Access is
      Result : Int_Access := new Integer;
   begin
      Result.All := Integer(Item(Parm2).all / 3.14149);
      return Result;
   end Complex_Func;

   -- Declare an access variable to hold the access to the function

   F_Ptr : Func_Access := Func_To_Be_Passed'access;

   -- Declare an access to integer variable to hold the result

   Int_Ptr : Int_Access;

begin

   -- Call the function using the access variable

   Int_Ptr := Complex_Func(F_Ptr, 3);
   Put_Line(Integer'Image(Int_Ptr.All));
end Subprogram_As_Argument_2;
