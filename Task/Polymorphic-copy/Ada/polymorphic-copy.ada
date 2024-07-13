with Ada.Text_IO;  use Ada.Text_IO;

procedure Test_Polymorphic_Copy is
   package Base is
      type T is tagged null record;
      type T_ptr is access all T'Class;
      function Name (X : T) return String;
   end Base;
   use Base;

   package body Base is
      function Name (X : T) return String is
      begin
         return "T";
      end Name;
   end Base;

      -- The procedure knows nothing about S
   procedure Copier (X : T'Class) is
      Duplicate : T'Class := X;  -- A copy of X
   begin
      Put_Line ("Copied " & Duplicate.Name); -- Check the copy
   end Copier;

      -- The function knows nothing about S and creates a copy on the heap
   function Clone (X : T'Class) return T_ptr is
   begin
      return new T'Class'(X);
   end Clone;

   package Derived is
      type S is new T with null record;
      overriding function Name (X : S) return String;
   end Derived;
   use Derived;

   package body Derived is
      function Name (X : S) return String is
      begin
         return "S";
      end Name;
   end Derived;

   Object_1 : T;
   Object_2 : S;
   Object_3 : T_ptr := Clone(Object_1);
   Object_4 : T_ptr := Clone(Object_2);
begin
   Copier (Object_1);
   Copier (Object_2);
   Put_Line ("Cloned " & Object_3.all.Name);
   Put_Line ("Cloned " & Object_4.all.Name);
end Test_Polymorphic_Copy;
