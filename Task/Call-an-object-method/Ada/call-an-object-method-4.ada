with Ada.Text_IO; use Ada.Text_IO;

procedure Call_Method is

   package My_Class is ... -- see above
   package body My_Class is ... -- see above

   package Other_Class is ... -- see above
   package body Other_Class is ... -- see above

   Ob1: My_Class.Object; -- our "root" type
   Ob2: Other_Class.Object; -- a type derived from the "root" type

begin
   My_Class.Static;
   Ob1.Primitive;
   Ob2.Primitive;
   Ob1.Dynamic;
   Ob2.Dynamic;
end Call_Method;
